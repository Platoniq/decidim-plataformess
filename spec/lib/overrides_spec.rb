# frozen_string_literal: true

require "spec_helper"

# We make sure that the checksum of the file overriden is the same
# as the expected. If this test fails, it means that the overriden
# file should be updated to match any change/bug fix introduced in the core
checksums = [
  {
    package: "decidim-admin",
    files: {
      "/app/commands/decidim/admin/create_scope.rb" => "dbe2cd817a921a6c8ef084205e30748c",
      "/app/forms/decidim/admin/scope_form.rb" => "4e5fc62ea52fce2065ac2caa562e94e4",
      "/app/views/decidim/admin/scopes/_form.html.erb" => "a63a3d4d02e6d6f641a9164193c0bfaa"
    }
  },
  {
    package: "decidim-conferences",
    files: {
      "/app/controllers/decidim/conferences/conferences_controller.rb" => "797899ada946b487a3c8c7312f0c14eb"
    }
  },
  {
    package: "decidim-core",
    files: {
      "/app/models/decidim/scope.rb" => "ff4f1fca1e564f29af58018ca7c60aa1"
    }
  }
]

describe "Overriden files", type: :view do
  checksums.each do |item|
    # rubocop:disable Rails/DynamicFindBy
    spec = ::Gem::Specification.find_by_name(item[:package])
    # rubocop:enable Rails/DynamicFindBy
    item[:files].each do |file, signature|
      it "#{spec.gem_dir}#{file} matches checksum" do
        expect(md5("#{spec.gem_dir}#{file}")).to eq(signature)
      end
    end
  end

  private

  def md5(file)
    Digest::MD5.hexdigest(File.read(file))
  end
end
