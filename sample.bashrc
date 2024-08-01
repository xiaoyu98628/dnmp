# 存放位置 ~/.bashrc
# ------------------------ start ------------------------
environment=$HOME/.environment
if [ -d ${environment} ];
then
    for file in `ls ${environment}`
    do
        if [ -f ${environment}/${file} ];
        then
            . ${environment}/${file}
        fi
    done
fi

# ------------------------ end ------------------------

# 存放位置 ~/.environment/php.sh
# ------------------------ start ------------------------
php72()
{
    tty=
    tty -s && tty=--tty
    docker run \
        $tty \
        --interactive \
        --rm \
        --volume $PWD:/var/www/html:rw \
        --workdir /var/www/html \
        dnmp_php72 php "$@"
}

php73()
{
    tty=
    tty -s && tty=--tty
    docker run \
        $tty \
        --interactive \
        --rm \
        --volume $PWD:/var/www/html:rw \
        --workdir /var/www/html \
        dnmp_php73 php "$@"
}

php74()
{
    tty=
    tty -s && tty=--tty
    docker run \
        $tty \
        --interactive \
        --rm \
        --volume $PWD:/var/www/html:rw \
        --workdir /var/www/html \
        dnmp_php74 php "$@"
}

php80()
{
    tty=
    tty -s && tty=--tty
    docker run \
        $tty \
        --interactive \
        --rm \
        --volume $PWD:/var/www/html:rw \
        --workdir /var/www/html \
        dnmp_php80 php "$@"
}

php81()
{
    tty=
    tty -s && tty=--tty
    docker run \
        $tty \
        --interactive \
        --rm \
        --volume $PWD:/var/www/html:rw \
        --workdir /var/www/html \
        dnmp_php80 php "$@"
}

# ------------------------ end ------------------------