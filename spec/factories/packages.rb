FactoryBot.define do
  factory :package, class: Packages::Package do
    project
    name 'my/company/app/my-app'
    version '1-0-SNAPSHOT'

    factory :maven_package do
      maven_metadatum

      after :create do |package|
        create :package_file, :xml, package: package
        create :package_file, :jar, package: package
        create :package_file, :pom, package: package
      end
    end
  end

  factory :package_file, class: Packages::PackageFile do
    package

    trait(:jar) do
      file Tempfile.new('my-app-1.0-20180724.124855-1.jar')
      file_name 'my-app-1.0-20180724.124855-1.jar'
      file_type 'jar'
    end

    trait(:pom) do
      file Tempfile.new('my-app-1.0-20180724.124855-1.pom')
      file_name 'my-app-1.0-20180724.124855-1.pom'
      file_type 'pom'
    end

    trait(:xml) do
      file Tempfile.new('maven-metadata.xml')
      file_name 'maven-metadata.xml'
      file_type 'xml'
    end
  end

  factory :maven_metadatum, class: Packages::MavenMetadatum do
    package
    app_group 'my/company/app'
    app_name 'my-app'
    app_version '1-0-SNAPSHOT'
  end
end
