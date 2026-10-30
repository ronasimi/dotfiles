#!/usr/bin/env python3
"""Control ronasimi/swift-1-5-qwen3-8-27b using Arch's kaggle-api package.

Install: yay -S kaggle-api   (or paru -S kaggle-api)
Authenticate: kaggle auth login, KAGGLE_API_TOKEN, or ~/.kaggle/kaggle.json.
Usage: ./kaggle-swift.py on|off|view|status

on pulls the latest SAVED source/metadata, creates a new saved run on T4 x2,
then follows logs. Unsaved browser edits are not included. Existing Kaggle
Secrets permissions must already be enabled for this notebook.
Ctrl-C detaches the log viewer; it does not stop the remote notebook.
off cancels only the run recorded by this script, never deletes the notebook.

Cancellation uses the generated SDK's cancel_kernel_session endpoint with
SaveKernel's returned version_number (upstream kaggle-cli issue #1172).
This integration must be verified against your installed package/backend;
errors are surfaced, and cancellation is checked rather than assumed.
Sources:
https://github.com/Kaggle/kaggle-cli/issues/1172
https://github.com/Kaggle/kaggle-cli/blob/main/skills/references/kernels.md
"""
import argparse
import fcntl
import json
import os
from pathlib import Path
import sys
import tempfile
import time

KERNEL = 'ronasimi/swift-1-5-qwen3-8-27b'
URL = 'https://www.kaggle.com/code/' + KERNEL
ROOT = Path(os.environ.get('XDG_STATE_HOME', str(Path.home() / '.local/state'))) / 'kaggle-swift'
STATE = ROOT / 'run.json'
TERMINAL = {'COMPLETE', 'COMPLETED', 'ERROR', 'FAILED', 'CANCELLED', 'CANCELED', 'CANCEL_ACKNOWLEDGED', 'NEW_SCRIPT'}


def load_state():
    if not STATE.exists():
        return None
    state = json.loads(STATE.read_text())
    if state.get('kernel') != KERNEL:
        raise RuntimeError('Saved state belongs to a different notebook; refusing to use it.')
    return state


def save_state(state):
    temp = STATE.with_suffix('.tmp')
    temp.write_text(json.dumps(state, indent=2) + '\n')
    temp.replace(STATE)


def run_ref(state):
    return f"{KERNEL}/{state['version']}" if state and state.get('version') else KERNEL


def status(api, ref):
    response = api.kernels_status(ref)
    value = response.status
    name = getattr(value, 'name', str(value)).rsplit('.', 1)[-1].upper()
    return name, getattr(response, 'failure_message', '')


def view(api, ref):
    if not callable(getattr(api, 'kernels_logs_cli', None)):
        raise RuntimeError('Your kaggle-api version lacks logs support. Update it through your AUR helper.')
    print(f'Following {ref}. Ctrl-C detaches; use off to stop the remote run.', flush=True)
    # Retry initial availability errors while the submitted version is provisioning.
    for attempt in range(12):
        try:
            api.kernels_logs_cli(ref, follow=True)
            return
        except Exception as exc:
            code = getattr(getattr(exc, 'response', None), 'status_code', None)
            if code not in (404, 409, 503) or attempt == 11:
                raise
            print('Logs not available yet; retrying in 5 seconds...', flush=True)
            time.sleep(5)


def start(api, args):
    # Exclusive lock is held by main, preventing simultaneous local submissions.
    old = load_state()
    if old and old.get('phase') == 'submitting':
        raise RuntimeError(f'A previous submission had an uncertain outcome. Check {URL} before removing {STATE}.')
    if old and old.get('version'):
        current, _ = status(api, run_ref(old))
        if current not in TERMINAL:
            print(f'Reusing recorded run {old["version"]}: {current}', flush=True)
            return run_ref(old)
    current, _ = status(api, KERNEL)
    if current not in TERMINAL:
        raise RuntimeError(f'Latest run is {current}, but is not managed by this script. Use view; stop it on Kaggle before on.')
    if not callable(getattr(api, 'kernels_logs_cli', None)):
        raise RuntimeError('Update kaggle-api through your AUR helper: this version lacks log following.')
    from kagglesdk.kernels.types.kernels_api_service import ApiCancelKernelSessionRequest
    with api.build_kaggle_client() as client:
        if not callable(getattr(client.kernels.kernels_api_client, 'cancel_kernel_session', None)):
            raise RuntimeError('Installed python-kagglesdk lacks cancellation support.')
    with tempfile.TemporaryDirectory(prefix='source-', dir=ROOT) as folder:
        print('Downloading latest saved notebook and metadata...', flush=True)
        api.kernels_pull(KERNEL, folder, metadata=True)
        path = Path(folder) / 'kernel-metadata.json'
        metadata = json.loads(path.read_text())
        if metadata.get('id') != KERNEL:
            raise RuntimeError('Downloaded metadata does not match the requested notebook.')
        metadata['enable_gpu'] = True
        metadata['enable_tpu'] = False
        metadata['enable_internet'] = True
        path.write_text(json.dumps(metadata, indent=2) + '\n')
        # Persist intent first: a lost connection must not trigger automatic duplicate jobs.
        state = {'kernel': KERNEL, 'phase': 'submitting', 'submitted_at': time.time()}
        save_state(state)
        print('Submitting a new saved run on T4 x2...', flush=True)
        result = api.kernels_push(folder, timeout=str(args.timeout), acc='NvidiaTeslaT4')
        if result is None:
            raise RuntimeError(f'No submission response; check {URL}. State retained to prevent duplicate runs.')
        if result.error:
            state['phase'] = 'rejected'
            save_state(state)
            raise RuntimeError(result.error)
        version = int(result.version_number)
        if version <= 0:
            raise RuntimeError(f'Submission returned no run identifier; check {URL}.')
        state.update(version=version, session_id=version, phase='submitted')
        save_state(state)
        print(f'Submitted run {version}. State: {STATE}', flush=True)
        for field in ('invalid_dataset_sources', 'invalid_kernel_sources', 'invalid_model_sources', 'invalid_competition_sources'):
            rejected = getattr(result, field, None)
            if rejected:
                print(f'WARNING: Kaggle rejected {field}: {rejected}', file=sys.stderr)
        return run_ref(state)


def stop(api):
    state = load_state()
    if not state or not state.get('session_id'):
        raise RuntimeError(f'No recorded run to cancel. Stop a browser-started or untracked run at {URL}.')
    ref = run_ref(state)
    current, _ = status(api, ref)
    if current in TERMINAL:
        print(f'Recorded run already ended: {current}')
        return
    from kagglesdk.kernels.types.kernels_api_service import ApiCancelKernelSessionRequest
    request = ApiCancelKernelSessionRequest()
    request.kernel_session_id = int(state['session_id'])
    with api.build_kaggle_client() as client:
        response = client.kernels.kernels_api_client.cancel_kernel_session(request)
    if response.error_message:
        raise RuntimeError('Kaggle rejected cancellation: ' + response.error_message)
    print(f'Cancellation requested for run {state["version"]}; checking status...', flush=True)
    for _ in range(24):
        time.sleep(5)
        current, detail = status(api, ref)
        if current in TERMINAL:
            state['phase'] = 'ended'
            save_state(state)
            print(f'Run ended: {current}' + (f' ({detail})' if detail else ''))
            return
    raise RuntimeError(f'Cancellation requested, but shutdown is not confirmed (status: {current}). Check {URL}.')


def main():
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument('action', choices=('on', 'off', 'view', 'status'))
    parser.add_argument('--no-view', action='store_true', help='on: submit without attaching to logs')
    parser.add_argument('--timeout', type=int, default=43200, help='on: requested run limit in seconds (default 43200; Kaggle limits apply)')
    args = parser.parse_args()
    if args.timeout <= 0:
        parser.error('--timeout must be positive')
    os.umask(0o077)
    ROOT.mkdir(parents=True, exist_ok=True)
    try:
        from kaggle.api.kaggle_api_extended import KaggleApi
    except ImportError as exc:
        raise RuntimeError('Install/update kaggle-api with yay or paru; run this script with /usr/bin/python.') from exc
    api = KaggleApi()
    api.authenticate()
    if args.action in ('on', 'off'):
        with (ROOT / 'control.lock').open('a') as lock:
            try:
                fcntl.flock(lock, fcntl.LOCK_EX | fcntl.LOCK_NB)
            except BlockingIOError:
                raise RuntimeError('Another on/off operation is in progress.')
            if args.action == 'off':
                stop(api)
                return
            ref = start(api, args)
        if not args.no_view:
            view(api, ref)
    else:
        ref = run_ref(load_state())
        if args.action == 'view':
            view(api, ref)
        else:
            current, detail = status(api, ref)
            print(f'{ref}: {current}' + (f' ({detail})' if detail else ''))


if __name__ == '__main__':
    try:
        main()
    except KeyboardInterrupt:
        print('\nDetached/interrupted locally. Remote shutdown is NOT implied; use off or status.', file=sys.stderr)
        sys.exit(130)
    except Exception as exc:
        print(f'Error: {exc}', file=sys.stderr)
        sys.exit(1)
