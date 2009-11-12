plugin_root = File.expand_path(File.join(File.dirname(__FILE__), '../..'))

namespace :acts_as_struct do
  namespace :copy do
    desc "copy migration files to RAILS_ROOT/db/migrate/"
    task :migrations do
      Dir.glob(File.join(plugin_root, 'db/migrate/*.rb')).each do |f|
        FileUtils.cp(f, File.join(RAILS_ROOT, 'db/migrate'))
      end
    end
  end
end

