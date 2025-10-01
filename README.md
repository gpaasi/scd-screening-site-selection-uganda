
# Uganda SCD–Malaria Siting

End-to-end R workflow to build HbS and PfPR rasters, construct a co-risk surface, 
select 50 sites with a 25 km service radius via greedy optimization, assess coverage/equity, 
and collocate proposed sites to implementable facilities using 2SFCA catchments.

## Quick start

1. Edit **scripts/00_setup_paths.R** to point to your local files.
2. Run scripts in order:
   - 03_pfpr_stack_and_mean.R
   - 04_build_corisk.R
   - 05_mask_unserved_25km.R (optional, if you have existing coverage)
   - 06_greedy_select_25km.R
   - 07_collocation_2sfca.R
   - 08_coverage_curves_and_milestones.R
   - 09_equity_lorenz_gini.R
   - 10_radius_sensitivity.R
   - 12_export_maps.R

Outputs are written to `data/processed/` and `figures/`.

## Dependencies

R >= 4.2 with packages: terra, dplyr, data.table, readr, sf, sp, gdistance, classInt.
See **scripts/install_pkgs.R**.

## License

MIT
