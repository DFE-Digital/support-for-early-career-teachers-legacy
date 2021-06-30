# frozen_string_literal: true

desc "Dump CIP content into a file"
task cip_seed_dump: :environment do
  CoreInductionProgrammeExporter.new.run

  sh "rm -f db/seeds/cip_seed.rb && cat db/seeds/cip_seed_dump.rb | sed 's/^\])/\], on_duplicate_key_update: { conflict_target: [:id], columns: :all })/' > db/seeds/cip_seed.rb"
end
