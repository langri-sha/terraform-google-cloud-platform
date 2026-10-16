import { Project } from '@langri-sha/projen-project'

const project = new Project({
  name: 'terraform-google-cloud-platform',
  package: {
    authorEmail: 'filip.dupanovic@gmail.com',
    authorName: 'Filip Dupanović',
    authorOrganization: false,
    authorUrl: 'https://langri-sha.com',
    bugsUrl:
      'https://github.com/langri-sha/terraform-google-cloud-platform/issues',
    homepage:
      'https://github.com/langri-sha/terraform-google-cloud-platform/#readme',
    minNodeVersion: '24.16.0',
    repository: 'langri-sha/terraform-google-cloud-platform',
    type: 'module',

    entrypoint: '',
    npmProvenance: false,

    copyrightYear: '2022',
    license: 'MIT',
    licensed: true,

    devDeps: ['@langri-sha/prettier@^0.4.7'],
    peerDependencyOptions: {
      pinnedDevDependency: false,
    },
  },
  codeowners: {
    '*': '@langri-sha',
  },
  editorConfig: {},
  lintSynthesized: {},
  pnpmWorkspace: {
    minimumReleaseAgeExclude: ['@langri-sha/*', ...Project.presetPackages],
  },
  prettier: {},
  renovate: {
    extends: ['github>langri-sha/renovate-config'],
    customManagers: [
      {
        customType: 'regex',
        datasourceTemplate: 'github-releases',
        depNameTemplate: 'hashicorp/terraform',
        extractVersionTemplate: '^v(?<version>.+)$',
        managerFilePatterns: ['/^\\.github/workflows/terraform\\.yml$/'],
        matchStrings: ['TERRAFORM_VERSION:\\s*(?<currentValue>\\S+)'],
      },
    ],
  },
  typeScriptConfig: {},
  withTerraform: true,
  worktrunk: {},

  gitIgnoreOptions: {
    ignorePatterns: ['.terraform.lock.hcl'],
  },
})

project.package?.addEngine('pnpm', '>= 11.0.0')
project.package?.addField('packageManager', 'pnpm@12.13.0')
project.package?.addField('private', true)

project.tryFindObjectFile('package.json')?.addDeletionOverride('pnpm')

project.synth()
