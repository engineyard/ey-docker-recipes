require 'chefspec'

describe 'docker_nodejs::setup_nginx' do
  let :chef_run do
    runner.converge described_recipe
  end

  let :runner do
    ChefSpec::SoloRunner.new platform: 'gentoo', version: '2.1' do |node|
      node.default['dna']
    end
  end
end
