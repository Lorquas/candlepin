#! /bin/bash

setup_mysql() {
    # moving install to setup-devel-env.sh
    # yum install -y mariadb mysql-connector-java

    mysql --user=root mysql --password=password --host=db --execute="CREATE USER 'candlepin'; GRANT ALL PRIVILEGES on candlepin.* TO 'candlepin' WITH GRANT OPTION"
    mysql --user=root mysql --password=password --host=db --execute="CREATE USER 'gutterball'; GRANT ALL PRIVILEGES on gutterball.* TO 'gutterball' WITH GRANT OPTION"
    mysqladmin --host=db --user="candlepin" create candlepin
    mysqladmin --hosth=db --user="gutterball" create gutterball

    echo "USE_MYSQL=\"1\"" >> /root/.candlepinrc
}

setup_postgres() {
  echo "IMPLEMENT ME"
}

setup_oracle() {
  echo "IMPLEMENT ME"
}

setup_database() {
  # normalize the flags with true/false
  USE_MYSQL=${USE_MYSQL:-'false'}
  USE_POSTGRES=${USE_POSTGRES:-'false'}
  USE_ORACLE=${USE_ORACLE:-'false'}

  # set a default
  if [ $USE_MYSQL = false ] && && [ $USE_POSTGRES = false ] && [ $USE_ORACLE = false ]; then
    # mysql for now
    USE_MYSQL=true
  fi

  if [ USE_MSQL = true ];
    setup_msql
  elif [USE_POSTGRES = true ];
    setup_postgres
  elif [ USE_ORACLE = true ];
    setup_oracle
  fi
}
