# empty config file full of fallbacks to get default.nix loading
# use this as a minimal template or example.config.nix for a full file
{
 release = {
  commit = "________________________________________";
  version = {
   current = "_._._";
   previous = "_._._";
  };

  hook = {
   preflight = ''
echo "<your preflight script here>"
   '';
   version = ''
echo "<your versioning script here>"
   '';
   publish = ''
echo "<your publishing script here>"
   '';
  };

  github = {
   owner = "<your github owner here>";
   repo = "<your repo name here>";
   template = ''
   {{ changelog }}
   <your release template markdown here>
   '';
  };
 };

 holo-nixpkgs = rec {
  use-github = true;

  github = rec {
   # can be any github ref
   # branch, tag, commit, etc.
   ref = "321bad660bb9d30e43ffccb740c396365b3b3930";

   # the sha of what is downloaded from the above ref
   # note: even if you change the above ref it will not be redownloaded until
   #       the sha here changes (the sha is the cache key for downloads)
   # note: to get a new sha, get nix to try and download a bad sha
   #       it will complain and tell you the right sha
   sha256 = "1x7gzndv8qax3wwv7imki9rrzm0l22qhf49bdkjjn6nb430fmlnk";

   # the github owner of the holonix repo
   owner = "Holo-Host";

   # the name of the holonix repo
   repo = "holo-nixpkgs";

  };

  # configuration for when use-github = false
  local = {
   # the path to the local holonix copy
   path = ../holo-nixpkgs;
  };

  importFn = _: import (
     if use-github
     then builtins.fetchTarball (with github; {
        url = "https://github.com/${owner}/${repo}/archive/${ref}.tar.gz";
        inherit sha256; }
       )
     else local.path
    ) {}
    ;
 };
}
