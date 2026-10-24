# apm placement benchmark

Performance comparison for [apm](https://github.com/microsoft/apm)'s `apm compile`,
before and after a placement optimizer fix, on synthetic monorepo-shaped
projects.

## Results

Minimum of several repeats. Memory is peak RSS of the `apm` process:

| project | directories | before | after | speedup | before MB | after MB |
|---|---:|---:|---:|---:|---:|---:|
| `proj_small` | ~6 | 0.25s | 0.24s | 1.0x | 66 | 66 |
| `proj_1000` | ~1000 | 2.69s | 0.58s | 4.7x | 75 | 74 |
| `proj_2000` | ~2000 | 7.95s | 0.91s | 8.8x | 85 | 83 |
| `proj_10000` | ~10000 | 153.11s | 3.70s | 41.3x | 165 | 153 |

Before = latest `main` (`29200432`); after = `perf/placement-large-tree-scaling-v3`.

Compile time grows superlinearly with directory count before the fix and
stays close to flat after. Peak RSS barely moves either way.

## Reproducing

Works on Linux, macOS and Windows; on Windows, run `setup_envs.sh` from Git Bash.

```sh
python generate_project.py proj_small --target-dirs 1
python generate_project.py proj_1000 --target-dirs 1000
python generate_project.py proj_2000 --target-dirs 2000
python generate_project.py proj_10000 --target-dirs 10000

./setup_envs.sh   # optionally: repo_url before_ref after_ref
python benchmark.py --projects proj_small proj_1000 proj_2000 proj_10000
```
