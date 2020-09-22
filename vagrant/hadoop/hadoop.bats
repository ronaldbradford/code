# hadoop/pig bash TDD

@test "bats present" {
  run type -P bats
  [ "${status}" -eq 0 ]
  echo ${output}
  [ "$(basename ${output})" = "bats" ]
}

@test "java command present" {
  run type -P java
  [ "${status}" -eq 0 ]
  echo ${output}
  [ "$(basename ${output})" = "java" ]
} 

@test "sha512sum command present" {
  run type -P sha512sum
  [ "${status}" -eq 0 ]
  echo ${output}
  [ "$(basename ${output})" = "sha512sum" ]
}

@test "hadoop command present" {
  run type -P hadoop
  [ "${status}" -eq 0 ]
  echo ${output}
  [ "$(basename ${output})" = "hadoop" ]
}

@test "pig command present" {
  run type -P pig
  [ "${status}" -eq 0 ]
  echo ${output}
  [ "$(basename ${output})" = "pig" ]
}

@test "JAVA_HOME is defined ${JAVA_HOME}" {
  [ -n "${JAVA_HOME}" ]
}
