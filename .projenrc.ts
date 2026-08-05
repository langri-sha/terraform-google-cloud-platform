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

    devDeps: [
      '@langri-sha/prettier@^0.4.2',
      'prettier-plugin-ini@^1.3.0',
      'prettier@3.9.6',
    ],
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
    minimumReleaseAgeExclude: ['@langri-sha/*'],
  },
  prettier: {},
  renovate: {
    packageRules: [
      {
        description: 'Packages published from the langri-sha/projen monorepo',
        groupName: 'langri-sha projen toolchain',
        groupSlug: 'langri-sha-projen',
        matchSourceUrls: ['https://github.com/langri-sha/projen'],
      },
      {
        description: 'Install our own packages without waiting them out',
        matchPackageNames: ['@langri-sha/**'],
        minimumReleaseAge: null,
      },
      {
        description:
          'Install our own GitHub Actions and Terraform modules without waiting them out',
        matchPackageNames: ['langri-sha/**'],
        minimumReleaseAge: null,
      },
    ],
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

  gitIgnoreOptions: {
    ignorePatterns: ['.terraform.lock.hcl'],
  },
})

project.package?.addEngine('pnpm', '>= 11.0.0')
project.package?.addField('packageManager', 'pnpm@11.19.0')
project.package?.addField('private', true)

project.tryFindObjectFile('package.json')?.addDeletionOverride('pnpm')

project.synth()
