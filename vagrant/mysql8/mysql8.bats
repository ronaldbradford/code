# mysql8 bash TDD

PKG_MANAGER="rpm"
MYSQL_VERSION="8"

@test "bats present" {
  run type -P bats
  [ "${status}" -eq 0 ]
  echo ${output}
  [ "$(basename ${output})" = "bats" ]
}

@test "${PKG_MANAGER} present" {
  run type -P ${PKG_MANAGER}
  [ "${status}" -eq 0 ]
  echo ${output}
  [ "$(basename ${output})" = "${PKG_MANAGER}" ]
}

# openssl is used to create new password during installation
@test "openssl present" {
  run type -P openssl
  [ "${status}" -eq 0 ]
  echo ${output}
  [ "$(basename ${output})" = "openssl" ]
}

@test "mysql ${PKG_MANAGER} install" {
  local PKG="mysql-community-server"
  run bash -c "${PKG_MANAGER} -qa ${PKG}| cut -c1-24"
  [ "${status}" -eq 0 ]
  [ "${output}" = "${PKG}-${MYSQL_VERSION}" ]
}

@test "mysql server command present" {
  run type -P mysqld
  [ "${status}" -eq 0 ]
  echo ${output}
  [ "$(basename ${output})" = "mysqld" ]
}

@test "mysql client command present" {
  run type -P mysql
  [ "${status}" -eq 0 ]
  echo ${output}
  [ "$(basename ${output})" = "mysql" ]
}

@test "mysqld running" {
  run pidof mysqld
  [ "${status}" -eq 0 ]
}

# Note: additional security to both access the server via ssh
#       and accessing sudo should be in place for production systems

@test "automated mysql access" {
  local EXPECTED="${USER}@localhost"
  run sudo mysql -NBe "SELECT USER()"
  [ "${status}" -eq 0 ]
  echo "${output} != ${EXPECTED}"
  [ "${output}" = "${EXPECTED}" ]
}
