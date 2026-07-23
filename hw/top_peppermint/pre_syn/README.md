# Peppermint Yosys Synthesis Exploration

```sh
./gen_flist.sh
mkdir -p out
yosys top_peppermint.ys 2>&1 | tee out/synth.log
./gen_area_report.sh
```
