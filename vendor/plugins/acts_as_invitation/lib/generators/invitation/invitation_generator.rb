class InvitationGenerator < Rails::Generator::NamedBase
  def manifest
    record do |m|
      m.class_collisions class_name
      
      m.template "app/models/mailer_template.rb", "app/models/#{file_name}_mailer.rb"
      m.template "app/models/model_template.rb", "app/models/#{file_name}.rb"
      m.directory File.join('app/views', "#{file_name}_mailer")
      m.template "app/views/email_template.rhtml", "app/views/#{file_name}_mailer/#{file_name}.rhtml"
      
      unless options[:skip_migration]
        m.directory 'db/migrate'
        m.migration_template 'db/migration.rb', 'db/migrate', :assigns => {
          :migration_name => "Create#{class_name.pluralize.gsub(/::/, '')}"
        }, :migration_file_name => "create_#{file_path.gsub(/\//, '_').pluralize}"
      end
      
      m.template "test/fixtures/model.yml", "test/fixtures/#{table_name}.yml"
      m.directory File.join('test/fixtures/', "#{file_name}_mailer")
      m.template "test/fixtures/mailer/mailer", "test/fixtures/#{file_name}_mailer/#{file_name}"
      m.template "test/unit/mailer_test.rb", "test/unit/#{file_name}_mailer.rb"
      m.template "test/unit/model_test.rb", "test/unit/#{file_name}.rb"
      
      m.readme "POST_GENERATION_REMINDER"
    end
  end
end