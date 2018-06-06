# Script to design layouts from spices

In this repo there are scripts to design group of layouts using ASTRAN tool and Docker.

---

# Requirements

Some requirements are needed:

## Docker

Docker is the company driving the container movement and the only container platform provider to address every application across the hybrid cloud.

These scripts are Docker (container) based and you need to install docker before running it.

You can get Docker [Community Edition](https://www.docker.com/community-edition) in [this link.](https://store.docker.com/search?type=edition&offering=community)

## ASTRAN

Astran is the heart of layout designing. You will need a version of ASTRAN to design layouts from spices. It is available in [ASTRAN site](http://aziesemer.github.io/astran/) or directly from [GitHub of Adriel Ziesemer](https://github.com/aziesemer/astran)

## Gurobi server license

[Gurobi](http://www.gurobi.com/) is 'The state-of-the-art mathematical programming solver for prescriptive analytics'. It is responsible for compaction step into layout design flow. You need a server license to run this script.

Actually, the Named User or Free Academic licenses doesn't run the scripts. You need have a server license because Docker containers host ID can't be changed. UFPel has a license. 

---

# Running

The command to run the scripts are: 
```
./design_layouts.sh --astran <full_path/to/astran/project> 
                    --spices <full_path/to/spices>
                    --rules <full_path/to/tech/rules/file> 
                    --gurobi_lic <full_path/to/gurobi/license/file>
                    --cores <num>,<num>,<num>
```

## Arguments
All arguments are required.

###  -\- astran <ful path/to/astran/project>
`--astran` argument define the `ful path for ASTRAN project`. You need to set the main ASTRAN folder for this argument.

###  -\- spices <ful path/to/spices>
Following `--spices` argument you need to type the `full path for spices folder`. In that folder must be all spices for designing.

###  -\- rules <ful path/to/tech/rules/file> 
`-- rules` set the `ful path for project rules`. ASTRAN support 65nm and 45nm node technology. Examples of rules are available in `Astran/build/Work/` directory at GitHub project.

###  -\- gurobi_lic <ful path/to/gurobi/license/file>
`-- gurobi_lic` define the `ful path for gurobi license file`. The license file normally will contain a single line with `TOKENSERVER=000.000.00.00` which `000.000.00.00` is the server IP address.

###  -\- cores <core_num>,<core_num>,<core_num>
`--cores` specify the CPU cores that will design the layouts. The cores design the layouts in parallel.

## Example
Here is a running example:

```
/home/ghsmaniotto/dev/design-astran-layouts/./design_layouts.sh --astran /home/ghsmaniotto/dev/astran --spices /home/ghsmaniotto/dev/spices --rules /home/ghsmaniotto/dev/astran/Astran/build/Work_test/tech_0065.rul --gurobi_lic /home/ghsmaniotto/dev/gurobi/gurobi.lic --cores 0,1,2
```

In this example the `scripts` are in the `/home/ghsmaniotto/dev/design-astran-layouts/` folder. It get ASTRAN tool from `/home/ghsmaniotto/dev/astran`. The spices for layout designing are in `/home/ghsmaniotto/dev/spices`. The layout design rules file is in ` `, the Gurobi license is in ` ` and finally, the layouts will be designed at three cores, CPU Core number 0, 1 and 2.

# Script Flow

This section detail the steps and flow to design a set of layouts.

## General

1 - Get input arguments;
2 - If there are previous simulation folders, it will compact all to a file in `DD_MM_YY__hh_mm.zip` format.
3 - If there are previous simulation folders, it will delete all.
4 - Create auxiliar folders. The directory will be like:
    
    |_design_layouts.sh
    |_run_docker_astran.sh
    |_in_execution
      |_< num >
        |_spices
        |_layout
      |_< num >
        |_spices
        |_layout
    |_not_designed
    |_final
      |_spices
      |_layouts
    |_initial

  - in_execution: Has a folder for each defined CPU core. In each folder, there are folders to store the spice and layout.
  - not_designed: Has the spices that can't be designed.
  - final: Has spices and layouts folders to store designed layouts.
  - initial: Have all spices defined in `--spices`. When exiting the execution, this folder is empty.

5 - Copy the spices in `--spice` argument folder to `initial` folder;
6 - Start Docker containers. Each CPU core will have a container running ASTRAN. Each container execute `run_docker_astran.sh` . What happens in the container is detailed below.

## In the container

The directory is shared between all containers. The steps in the container are:

1 - Move a spice in `initial` folder to it `spice` folder;
2 - Set GND and VDD net names;
3 - Create ASTRAN script according to ASTRAN's shell commands. This script is named `comandos.run`;
4 - Run ASTRAN in shell mode with `comandos.run` script;
5 - If the layout is designed:
  - Move spice to `final/layout` and layout to `final/layout` folders;

6 - If the layout is not designed:
  - Move spice to `not_designed` folder;

7 - If there is spice file in `initial` folder, go to step 1;
8 - Else, exit the execution; 

# Author

Gustavo Henrique Smaniotto.
[GitHub](https://github.com/ghsmaniotto)
[LinkedIn](www.linkedin.com/in/ghsmaniotto)