# Script to desing layouts from spices

In this repo there are scripts to design group of layouts using ASTRAN tool and Docker.

---

# Requirements

Some requirements are needed:

## Docker

Docker is the company driving the container movement and the only container platform provider to address every application across the hybrid cloud.

These scripts are Docker (container) based and you need to install docker before run it.

You can get Docker [Community Edition](https://www.docker.com/community-edition) in [this link.](https://store.docker.com/search?type=edition&offering=community)

## ASTRAN

Astran is the heart of layout designing. You will need a version of ASTRAN to design layouts from spices. It is available in [ASTRAN site](http://aziesemer.github.io/astran/) or directly from [GitHub of Adriel Ziesemer](https://github.com/aziesemer/astran)

## Gurobi server license

[Gurobi](http://www.gurobi.com/) is 'The state-of-the-art mathematical programming solver for prescriptive analytics'. It is reponsible for compaction step into layout design flow. You need a server license to run this script.

Actually the Named User or Free Academic licenses doesn't run the scripts. You need have a server license becaus Docker containers. UFPel has a license. 

---

# Running

The command to run the scripts are: 
```
./design_layouts.sh --astran <full_path/to/astran/project> 
					--spices <full_path/to/spices>
					--rules <full_path/to/tech/rules/file> 
					--gurobi_lic <full_path/to/gurobi/license/file>
					--cores <num>,<num>,<num>"
```

## Arguments
All arguments are required.

###  -\- astran <ful path/to/astran/project>
`--astran` argument define the `ful path for ASTRAN project`. You need to set the main ASTRAN folder for this argument.

###  -\- spices <ful path/to/spices>
Following `--spices` argument you need to type the `ful path for spices folder`. In that folder must be all spices for designing.

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

In this example the `scripts` are in the `/home/ghsmaniotto/dev/design-astran-layouts/` folder. It get ASTRAN tool from `/home/ghsmaniotto/dev/astran`. The spices for layout designing are in `/home/ghsmaniotto/dev/spices`. The layout design rules fie is in ` `, the Gurobi license is in ` ` and finnaly, the layouts will designed at three cores, CPU Core number 0, 1 and 2.

