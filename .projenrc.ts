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
    minNodeVersion: '24.22.1',
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
  claude: {
    settings: {
      attribution: { commit: '', pr: '', sessionUrl: false },
    },
  },
  codeowners: {
    '*': '@langri-sha',
  },
  dagger: {},
  editorConfig: {},
  githubTemplates: {},
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
  skills: {
    ignore: false,
    skills: [
      {
        source: 'langri-sha/skills',
        ref: 'c0cb19cc68f9c597ac580c0e415bf99dcb69d3fd',
        skills: ['create-commit', 'create-pr'],
      },
    ],
  },
})

project.package?.addEngine('pnpm', '>= 11.0.0')
project.package?.addField('packageManager', 'pnpm@12.15.0')
project.package?.addField('private', true)

project.tryFindObjectFile('package.json')?.addDeletionOverride('pnpm')

project.synth()
