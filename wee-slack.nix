with import <nixpkgs> {};

# nix-build wee-slack.nix
# cp -vif result/wee_slack.py ~/.weechat/python/autoload
let
  env = buildEnv {
    name = "deps";
    paths = [ python27Packages.websocket_client python27Packages.six ];
  };
in stdenv.mkDerivation {
  name = "wee-slack";
  src = fetchFromGitHub {
    owner = "wee-slack";
    repo = "wee-slack";
    rev = "221dfc528d7df5460b5d0014d28a6dd6f733ca7b";
    sha256 = "0712zzscgylprnnpgy2vr35a5mdqhic8kag5v3skhd84awbvk1n5";
  };
  patches = [ ./wee_slack.patch ./libpath.patch ./stringio.patch ];
  NIX_OUTPUT = "${env}/lib/python2.7/site-packages";
  installPhase = ''
    mkdir $out
    substitute wee_slack.py $out/wee_slack.py --subst-var NIX_OUTPUT
  '';
}
