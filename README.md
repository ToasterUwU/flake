This is my NixOS flake. If you dont know what this is, here is a little list of facts.

- NixOS is a Linux Distro that can be configured in a single config file
  - Every program you want to install is in the config
  - Every config file you want to have is in the config
  - Every driver you want is in the config
  - Every service you need is in the config
  - EVERYTHING is in the config
- NixOS has an experimental feature called flakes
  - They are an alternative to the normal/old config system
  - A flake is a module
  - A flake can import other flakes
  - A flake has multiple use cases
    - As a system config
    - As a submodule for a system config
    - As a definition of an installable program

> Can i use this flake for my own computers?

Yesnt. There are a few files you will need to replace or change.
- Every hardware-configuration.nix is specific to my hardware, you need to replace them with your own
- Some parts of the config may not work for you, for example, i use a AMD GPU, if you arent the amd-gpu.nix file wont do you any good.
- Everything that is in the `secrets` folder or uses something from it wont work unless you replace this with your own things
- Sometimes there are things specific to me, like my git username and email config in dev-work.nix
- The hostnames would work if you want to use them, but they are very individual to me, so you probably want different ones


If you change these parts, you can absolutely use my config if you wanted to.



`Thanks to @Scrumplex for the Template and explanations`