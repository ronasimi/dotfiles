# by vincentaxhe from China
#!/bin/perl
use strict;
use utf8;
use JSON;
use Getopt::Std;
my $usage = "Usage: $0 -[fcm]";
getopts("fcm", \my %options) or die $usage;
my %arg = reverse %options or die $usage;
my $mode = $arg{1};
my $clients_json = qx(hyprctl -j clients);
my $activeworkspace_json = qx(hyprctl -j activeworkspace);
my $clients = decode_json $clients_json;
my $activeworkspace = decode_json $activeworkspace_json;
my $workspacename = $activeworkspace->{name};
my @sortedwindows = sort {$a->{focusHistoryID} <=> $b->{focusHistoryID}} @$clients;
my (@addressarr, @menuarr);
my $i = 0;
foreach my $window (@sortedwindows){
	if ($window->{title}){
		push @addressarr, $window->{address};
		push @menuarr, join "\t", $i++, "workspace：".$window->{workspace}{name}, $window->{title};
	}
}
my $menu = join "\n", @menuarr;
my %promt = (f => "focuswindow", c => "close window", m => "movetoworkspace $workspacename");
my $out = qx(echo "$menu"|wofi --dmenu -W 40% -O alphabetical -p "$promt{$mode}") or die;
my $index = (split /\t/, $out)[0];
my $dest = $addressarr[$index] or die;
my %hyprdispatchs = (
	f => ["hyprctl", "dispatch", "focuswindow", "address:$dest"],
	c => ["hyprctl", "dispatch", "closewindow", "address:$dest"],
	m => ["hyprctl", "--batch", "dispatch focuswindow address:$dest; dispatch movetoworkspace $workspacename"]
);
exec $hyprdispatchs{$mode}->@*;