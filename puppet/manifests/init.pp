class puppet {
  package { 'libaugeas0':
    ensure  => installed,
  }

  package { 'augeas-lenses':
    ensure  => installed,
  }

  package { 'augeas-tools':
    ensure  => installed,
  }

  package { 'libaugeas-ruby':
    ensure  => installed,
  }
}
