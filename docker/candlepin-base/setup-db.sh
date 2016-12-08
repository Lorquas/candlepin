#! /bin/bash

retry() {
    local -r -i max_attempts="$1"; shift
    local -r cmd="$@"
    local -i attempt_num=1

    until $cmd
    do
        if (( attempt_num == max_attempts ))
        then
            echo "Attempt $attempt_num failed and there are no more attempts left!"
            return 1
        else
            #echo "Attempt $attempt_num failed! Trying again in $attempt_num seconds..."
            sleep $(( attempt_num++ ))
        fi
    done
}

setup_mysql() {
    # moving install to setup-devel-env.sh
    # yum install -y mariadb mysql-connector-java

		# wait for sql container to spin up
    retry 20 mysqladmin --host=db --user=root --password=password status

    mysql --user=root mysql --password=password --host=db --execute="CREATE USER 'candlepin'; GRANT ALL PRIVILEGES on candlepin.* TO 'candlepin' WITH GRANT OPTION"
    mysql --user=root mysql --password=password --host=db --execute="CREATE USER 'gutterball'; GRANT ALL PRIVILEGES on gutterball.* TO 'gutterball' WITH GRANT OPTION"
    mysqladmin --host=db --user="candlepin" create candlepin
    mysqladmin --host=db --user="gutterball" create gutterball

    echo "USE_MYSQL=\"1\"" >> /root/.candlepinrc
}

setup_postgres() {
    # Moving to setup-devel-env.sh
    # yum install -y postgresql postgresql-server postgresql-jdbc

    initdbcmd="/usr/bin/initdb --pgdata='$PGDATA' --auth='ident' --auth='trust'"

    postgres -h db -c "$initdbcmd" >> "$PGLOG" 2>&1 < /dev/null
    postgres -h db -c 'createuser -dls candlepin'
    postgres -h db -c 'createuser -dls gutterball'
}

setup_oracle() {
  echo "IMPLEMENT ME"
}

setup_database() {
  # normalize the flags with true/false
  USING_MYSQL=${USING_MYSQL:-'false'}
  USING_POSTGRES=${USING_POSTGRES:-'false'}
  USING_ORACLE=${USING_ORACLE:-'false'}

  # set a default
  if [ $USING_MYSQL = false ] && [ $USING_POSTGRES = false ] && [ $USING_ORACLE = false ]; then
    # mysql for now
    USING_MYSQL=true
  fi

  if [ $USING_MYSQL = true ]; then
    setup_mysql
  elif [ $USING_POSTGRES = true ]; then
    setup_postgres
  elif [ $USING_ORACLE = true ]; then
    setup_oracle
  fi
}
