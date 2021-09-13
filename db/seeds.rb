# frozen_string_literal: true

# store all seeds inside the folder db/seeds

load Rails.root.join("db/seeds/cip_seed.rb").to_s

load Rails.root.join("db/seeds/cohort_seed.rb").to_s

load Rails.root.join("db/seeds/dummy_structures.rb").to_s
