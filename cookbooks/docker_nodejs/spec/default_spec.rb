require 'chefspec'

describe 'docker_nodejs::default' do
  let :chef_run do
    runner.converge described_recipe
  end

  let :runner do
    ChefSpec::SoloRunner.new platform: 'gentoo', version: '2.1' do |node|
      node.default['dna']
    end
  end

  context 'in a utility instance named *docker*' do
    let :runner do
      ChefSpec::SoloRunner.new platform: 'gentoo', version: '2.1' do |node|
        node.default['dna'].tap do |dna|
          dna['instance_role'] = 'util'
          dna['name'] = 'docker'
        end
      end
    end

    it do
      expect(chef_run).to include_recipe 'docker_nodejs::setup_container'
    end
  end

  context 'when node[docker_nodejs][utility_name] is set' do
    let :runner do
      ChefSpec::SoloRunner.new platform: 'gentoo', version: '2.1' do |node|
        node.set['docker_nodejs']['utility_name'] = 'another_util'
        node.default['dna'].tap do |dna|
          dna['instance_role'] = 'util'
          dna['name'] = 'docker'
        end
      end
    end

    context 'in a utility instance named another_util' do
      before do
        runner.node.override['dna'].tap do |dna|
          dna['instance_role'] = 'util'
          dna['name'] = 'another_util'
        end
      end

      it  do
        expect(chef_run).to include_recipe 'docker_nodejs::setup_container'
      end
    end

    it  do
      expect(chef_run).to_not include_recipe 'docker_nodejs::setup_container'
    end
  end

  context 'in other instances' do
    it do
      expect(chef_run).to_not include_recipe 'docker_nodejs::setup_container'
    end
  end
end
