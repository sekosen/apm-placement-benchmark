# apm placement benchmark

Performance comparison for [apm](https://github.com/microsoft/apm)'s `apm compile`,
before and after a placement optimizer fix, on synthetic monorepo-shaped
projects.

## Results

Minimum of several repeats. Memory is peak RSS of the `apm` process:

| project | directories | before | after | speedup | before MB | after MB |
|---|---:|---:|---:|---:|---:|---:|
| `proj_small` | ~6 | 0.25s | 0.25s | 1.0x | 64 | 65 |
| `proj_1000` | ~1000 | 2.70s | 0.58s | 4.6x | 74 | 73 |
| `proj_2000` | ~2000 | 8.03s | 0.92s | 8.7x | 84 | 82 |
| `proj_10000` | ~10000 | 153.92s | 3.76s | 41.0x | 164 | 151 |

Before = latest `main` (`2e2d0683`); after = `perf/placement-large-tree-scaling-v3`.

Compile time grows superlinearly with directory count before the fix and
stays close to flat after. Peak RSS barely moves either way.

## Reproducing

```sh
python generate_project.py proj_small --target-dirs 1
python generate_project.py proj_1000 --target-dirs 1000
python generate_project.py proj_2000 --target-dirs 2000
python generate_project.py proj_10000 --target-dirs 10000

./setup_envs.sh   # optionally: repo_url before_ref after_ref
python benchmark.py --projects proj_small proj_1000 proj_2000 proj_10000
```
