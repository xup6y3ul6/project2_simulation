# Results

Three-level model for simulation studies
- 3l: three-level
- lmm: linear mixed-effect model
- ssm: state-space model for representing AR(1)
- ARd: autoregressive process for days
- Hd: heterogeneity of variances/standard deviations between days
- ADm: autoregressive process for moments
- Hm: heterogeneity of variances/standard deviations between moments


# Update on 2025-Jul-26


## 3l-lmm

| lmm         |D = 40 / M = 5|D = 20 / M = 10|
|-------------|--------------|---------------|
|             |[1](https://xup6y3ul6.github.io/project2_simulation/results/sim_3l-lmm__N20D40M5_phi-d0_Seed20250624_result.html)|[2](https://xup6y3ul6.github.io/project2_simulation/results/sim_3l-lmm__N20D20M10_phi-d0_Seed20250624_result.html)|

## 3l-lmm_Hd
| lmm         |D = 40 / M = 5|D = 20 / M = 10|
|-------------|--------------|---------------|
|             |[3](https://xup6y3ul6.github.io/project2_simulation/results/sim_3l-lmm_Hd_N20D40M5_phi-d0_Seed20250624_result.html)|[4](https://xup6y3ul6.github.io/project2_simulation/results/sim_3l-lmm_Hd_N20D20M10_phi-d0_Seed20250624_result.html)|


## 3l-lmm(ssm)_ARd
| lmm         |D = 40 / M = 5|D = 20 / M = 10|
|-------------|--------------|---------------|
|$phi_d = 0.1$|[5](https://xup6y3ul6.github.io/project2_simulation/results/sim_3l-lmm_ARd_N20D40M5_phi-d0.1_Seed20250624_result.html)|[8](https://xup6y3ul6.github.io/project2_simulation/results/sim_3l-lmm_ARd_N20D20M10_phi-d0.1_Seed20250624_result.html)|
|$phi_d = 0.3$|[6](https://xup6y3ul6.github.io/project2_simulation/results/sim_3l-lmm_ARd_N20D40M5_phi-d0.3_Seed20250624_result.html)|[9](https://xup6y3ul6.github.io/project2_simulation/results/sim_3l-lmm_ARd_N20D20M10_phi-d0.3_Seed20250624_result.html)|
|$phi_d = 0.5$|[7](https://xup6y3ul6.github.io/project2_simulation/results/sim_3l-lmm_ARd_N20D40M5_phi-d0.5_Seed20250624_result.html)|[10](https://xup6y3ul6.github.io/project2_simulation/results/sim_3l-lmm_ARd_N20D20M10_phi-d0.5_Seed20250624_result.html)|

| ssm         |D = 40 / M = 5|D = 20 / M = 10|
|-------------|--------------|---------------|
|$phi_d = 0.1$|[5'](https://xup6y3ul6.github.io/project2_simulation/results/sim_3l-ssm_ARd_N20D40M5_phi-d0.1_Seed20250624_result.html)||
|$phi_d = 0.3$||[9'](https://xup6y3ul6.github.io/project2_simulation/results/sim_3l-ssm_ARd_N20D20M10_phi-d0.3_Seed20250624_result.html)|
|$phi_d = 0.5$|[7'](https://xup6y3ul6.github.io/project2_simulation/results/sim_3l-ssm_ARd_N20D40M5_phi-d0.5_Seed20250624_result.html)|[10'](https://xup6y3ul6.github.io/project2_simulation/results/sim_3l-ssm_ARd_N20D20M10_phi-d0.5_Seed20250624_result.html)|


## 3l-lmm(ssm)_ARdHd

| lmm         |D = 40 / M = 5|D = 20 / M = 10|
|-------------|--------------|---------------|
|$phi_d = 0.1$|[11](https://xup6y3ul6.github.io/project2_simulation/results/sim_3l-lmm_ARdHd_N20D40M5_phi-d0.1_Seed20250624_result.html)|[14](https://xup6y3ul6.github.io/project2_simulation/results/sim_3l-lmm_ARdHd_N20D20M10_phi-d0.1_Seed20250624_result.html)|
|$phi_d = 0.3$|[12](https://xup6y3ul6.github.io/project2_simulation/results/sim_3l-lmm_ARdHd_N20D40M5_phi-d0.3_Seed20250624_result.html)|[15](https://xup6y3ul6.github.io/project2_simulation/results/sim_3l-lmm_ARdHd_N20D20M10_phi-d0.3_Seed20250624_result.html)|
|$phi_d = 0.5$|[13](https://xup6y3ul6.github.io/project2_simulation/results/sim_3l-lmm_ARdHd_N20D40M5_phi-d0.5_Seed20250624_result.html)|[16](https://xup6y3ul6.github.io/project2_simulation/results/sim_3l-lmm_ARdHd_N20D20M10_phi-d0.5_Seed20250624_result.html)|

| ssm         |D = 40 / M = 5|D = 20 / M = 10|
|-------------|--------------|---------------|
|$phi_d = 0.1$|[11'](https://xup6y3ul6.github.io/project2_simulation/results/sim_3l-ssm_ARdHd_N20D40M5_phi-d0.1_Seed20250624_result.html)|[14'](https://xup6y3ul6.github.io/project2_simulation/results/sim_3l-ssm_ARdHd_N20D20M10_phi-d0.1_Seed20250624_result.html)|
|$phi_d = 0.3$|[12'](https://xup6y3ul6.github.io/project2_simulation/results/sim_3l-ssm_ARdHd_N20D40M5_phi-d0.3_Seed20250624_result.html)|[15'](https://xup6y3ul6.github.io/project2_simulation/results/sim_3l-ssm_ARdHd_N20D20M10_phi-d0.3_Seed20250624_result.html)|
|$phi_d = 0.5$|[13'](https://xup6y3ul6.github.io/project2_simulation/results/sim_3l-ssm_ARdHd_N20D40M5_phi-d0.5_Seed20250624_result.html)|[16'](https://xup6y3ul6.github.io/project2_simulation/results/sim_3l-ssm_ARdHd_N20D20M10_phi-d0.5_Seed20250624_result.html)|

## 3l-lmm(ssm)_ARdARm

| lmm         |D = 40 / M = 5|D = 20 / M = 10|
|-------------|--------------|---------------|
|$phi_d = 0.1$|[17](https://xup6y3ul6.github.io/project2_simulation/results/sim_3l-lmm_ARdARm_N20D40M5_phi-d0.1_Seed20250624_result.html)|[20](https://xup6y3ul6.github.io/project2_simulation/results/sim_3l-lmm_ARdARm_N20D20M10_phi-d0.1_Seed20250624_result.html)|
|$phi_d = 0.3$|[18](https://xup6y3ul6.github.io/project2_simulation/results/sim_3l-lmm_ARdARm_N20D40M5_phi-d0.3_Seed20250624_result.html)|[21](https://xup6y3ul6.github.io/project2_simulation/results/sim_3l-lmm_ARdARm_N20D20M10_phi-d0.3_Seed20250624_result.html)|
|$phi_d = 0.5$|[19](https://xup6y3ul6.github.io/project2_simulation/results/sim_3l-lmm_ARdARm_N20D40M5_phi-d0.5_Seed20250624_result.html)|[22](https://xup6y3ul6.github.io/project2_simulation/results/sim_3l-lmm_ARdARm_N20D20M10_phi-d0.5_Seed20250624_result.html)|

| ssm         |D = 40 / M = 5|D = 20 / M = 10|
|-------------|--------------|---------------|
|$phi_d = 0.1$||[20'](https://xup6y3ul6.github.io/project2_simulation/results/sim_3l-ssm_ARdARm_N20D20M10_phi-d0.1_Seed20250624_result.html)|
|$phi_d = 0.3$|[18'](https://xup6y3ul6.github.io/project2_simulation/results/sim_3l-ssm_ARdARm_N20D40M5_phi-d0.3_Seed20250624_result.html)|[21'](https://xup6y3ul6.github.io/project2_simulation/results/sim_3l-ssm_ARdARm_N20D20M10_phi-d0.3_Seed20250624_result.html)|
|$phi_d = 0.5$|[19'](https://xup6y3ul6.github.io/project2_simulation/results/sim_3l-ssm_ARdARm_N20D40M5_phi-d0.5_Seed20250624_result.html)||
## 3l-lmm(ssm)_ARdHdARmHm

| lmm         |D = 40 / M = 5|D = 20 / M = 10|
|-------------|--------------|---------------|
|$phi_d = 0.1$|[23](https://xup6y3ul6.github.io/project2_simulation/results/sim_3l-lmm_ARdHdARmHm_N20D40M5_phi-d0.1_Seed20250624_result.html)|[26](https://xup6y3ul6.github.io/project2_simulation/results/sim_3l-lmm_ARdHdARmHm_N20D20M10_phi-d0.1_Seed20250624_result.html)|
|$phi_d = 0.3$|[24](https://xup6y3ul6.github.io/project2_simulation/results/sim_3l-lmm_ARdHdARmHm_N20D40M5_phi-d0.3_Seed20250624_result.html)|[27](https://xup6y3ul6.github.io/project2_simulation/results/sim_3l-lmm_ARdHdARmHm_N20D20M10_phi-d0.3_Seed20250624_result.html)|
|$phi_d = 0.5$|[25](https://xup6y3ul6.github.io/project2_simulation/results/sim_3l-lmm_ARdHdARmHm_N20D40M5_phi-d0.5_Seed20250624_result.html)|[28](https://xup6y3ul6.github.io/project2_simulation/results/sim_3l-lmm_ARdHdARmHm_N20D20M10_phi-d0.5_Seed20250624_result.html)|

| ssm         |D = 40 / M = 5|D = 20 / M = 10|
|-------------|--------------|---------------|
|$phi_d = 0.1$|[23'](https://xup6y3ul6.github.io/project2_simulation/results/sim_3l-ssm_ARdHdARmHm_N20D40M5_phi-d0.1_Seed20250624_result.html)|[26'](https://xup6y3ul6.github.io/project2_simulation/results/sim_3l-ssm_ARdHdARmHm_N20D20M10_phi-d0.1_Seed20250624_result.html)|
|$phi_d = 0.3$|[24'](https://xup6y3ul6.github.io/project2_simulation/results/sim_3l-ssm_ARdHdARmHm_N20D40M5_phi-d0.3_Seed20250624_result.html)|[27'](https://xup6y3ul6.github.io/project2_simulation/results/sim_3l-ssm_ARdHdARmHm_N20D20M10_phi-d0.3_Seed20250624_result.html)|
|$phi_d = 0.5$|[25'](https://xup6y3ul6.github.io/project2_simulation/results/sim_3l-ssm_ARdHdARmHm_N20D40M5_phi-d0.5_Seed20250624_result.html)|[28'](https://xup6y3ul6.github.io/project2_simulation/results/sim_3l-ssm_ARdHdARmHm_N20D20M10_phi-d0.5_Seed20250624_result.html)|


# Update on 2025-Jul-24

| Original | SSM representation |
|----------|--------------------|
|1. [3l-lmm](https://xup6y3ul6.github.io/project2_simulation/results/sim_3l-lmm__N20D20M20Seed20250611_result.html) | |
|2. [3l-lmm_ARd](https://xup6y3ul6.github.io/project2_simulation/results/sim_3l-lmm_ARd_N20D20M20Seed20250611_result.html) | 2'. [3l-ssm_ARd](https://xup6y3ul6.github.io/project2_simulation/results/sim_3l-ssm_ARd_N20D20M20Seed20250611_result.html) | |
|3. [3l-lmm_ARm](https://xup6y3ul6.github.io/project2_simulation/results/sim_3l-lmm_ARm_N20D20M20Seed20250611_result.html) | 3'. [3l-ssm_ARm](https://xup6y3ul6.github.io/project2_simulation/results/sim_3l-ssm_ARm_N20D20M20Seed20250611_result.html) | |
|4. [3l-lmm_Hd](https://xup6y3ul6.github.io/project2_simulation/results/sim_3l-lmm_Hd_N20D20M20Seed20250611_result.html) | |
|5. [3l-lmm_Hm](https://xup6y3ul6.github.io/project2_simulation/results/sim_3l-lmm_Hm_N20D20M20Seed20250611_result.html) | |
|6. [3l-lmm_HdHm](https://xup6y3ul6.github.io/project2_simulation/results/sim_3l-lmm_HdHm_N20D20M20Seed20250611_result.html) | |
|7. [3l-lmm_ARmHm](https://xup6y3ul6.github.io/project2_simulation/results/sim_3l-lmm_ARmHm_N20D20M20Seed20250611_result.html) | |
|8. [3l-lmm_ARdHd](https://xup6y3ul6.github.io/project2_simulation/results/sim_3l-lmm_ARdHd_N20D20M20Seed20250611_result.html) | |
|9. [3l-lmm_ARdARm](https://xup6y3ul6.github.io/project2_simulation/results/sim_3l-lmm_ARdARm_N20D20M20Seed20250611_result.html) | 9'. [3l-ssm_ARdARm](https://xup6y3ul6.github.io/project2_simulation/results/sim_3l-ssm_ARdARm_N20D20M20Seed20250611_result.html) |
|10. [3l-lmm_ARdARmHm](https://xup6y3ul6.github.io/project2_simulation/results/sim_3l-lmm_ARdARmHm_N20D20M20Seed20250611_result.html) | |
|11. [3l-lmm_ARdHdARmHm](https://xup6y3ul6.github.io/project2_simulation/results/sim_3l-lmm_ARdHdARmHm_N20D20M20Seed20250611_result.html) | 11'. [3l-ssm_ARdHdARmHm](https://xup6y3ul6.github.io/project2_simulation/results/sim_3l-ssm_ARdHdARmHm_N20D20M20Seed20250611_result.html) |


# Update on 2025-Jul-19

## 3l-lmm
|             |D = 40 / M = 5|D = 20 / M = 10|
|-------------|--------------|---------------|
|$phi_d = 0.1$|[Finished](https://xup6y3ul6.github.io/project2_simulation/results/sim_3l-lmm__N20D40M5phi_d0.1Seed20250617_result.html)|[Failed]()|
|$phi_d = 0.3$|[Failed]()|[Failed]()|
|$phi_d = 0.5$|[Failed]()|[Finished](https://xup6y3ul6.github.io/project2_simulation/results/sim_3l-lmm__N20D20M10phi_d0.5Seed20250617_result.html)|

## 3l-lmm_Hd

|             |D = 40 / M = 5|D = 20 / M = 10|
|-------------|--------------|---------------|
|$phi_d = 0.1$|[Finished](https://xup6y3ul6.github.io/project2_simulation/results/sim_3l-lmm_Hd_N20D40M5phi_d0.1Seed20250617_result.html)|[Finished](https://xup6y3ul6.github.io/project2_simulation/results/sim_3l-lmm_Hd_N20D20M10phi_d0.1Seed20250617_result.html)|
|$phi_d = 0.3$|[Failed]()|[Failed]()|
|$phi_d = 0.5$|[Finished](https://xup6y3ul6.github.io/project2_simulation/results/sim_3l-lmm_Hd_N20D40M5phi_d0.1Seed20250617_result.html)|[Finished](https://xup6y3ul6.github.io/project2_simulation/results/sim_3l-lmm_Hd_N20D20M10phi_d0.5Seed20250617_result.html)|

## 3l-lmm_ARd

|             |D = 40 / M = 5|D = 20 / M = 10|
|-------------|--------------|---------------|
|$phi_d = 0.1$|[Failed]()|[Failed]()|
|$phi_d = 0.3$|[Failed]()|[Finished](https://xup6y3ul6.github.io/project2_simulation/results/sim_3l-lmm_ARd_N20D20M10phi_d0.3Seed20250617_result.html)|
|$phi_d = 0.5$|[Finished](https://xup6y3ul6.github.io/project2_simulation/results/sim_3l-lmm_ARd_N20D40M5phi_d0.5Seed20250617_result.html)|[Finished](https://xup6y3ul6.github.io/project2_simulation/results/sim_3l-lmm_ARd_N20D20M10phi_d0.5Seed20250617_result.html)|

## 3l-lmm_ARdHd

|             |D = 40 / M = 5|D = 20 / M = 10|
|-------------|--------------|---------------|
|$phi_d = 0.1$|[Finished](https://xup6y3ul6.github.io/project2_simulation/results/sim_3l-lmm_ARdHd_N20D40M5phi_d0.1Seed20250617_result)|[Finished](https://xup6y3ul6.github.io/project2_simulation/results/sim_3l-lmm_ARdHd_N20D20M10phi_d0.1Seed20250617_result.html)|
|$phi_d = 0.3$|[Failed]()|[Failed]()|
|$phi_d = 0.5$|[Finished](https://xup6y3ul6.github.io/project2_simulation/results/sim_3l-lmm_ARdHd_N20D40M5phi_d0.5Seed20250617_result)|[Finished](https://xup6y3ul6.github.io/project2_simulation/results/sim_3l-lmm_ARdHd_N20D20M10phi_d0.5Seed20250617_result.html)|
