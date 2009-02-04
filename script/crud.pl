use strict;
use warnings;
use Test::More tests => 10;
use Neko::DB::User;
use Data::Model::Driver::DBI;

my $dm = Neko::DB::User->new();

# ドライバ情報をつっこみまくる
{
    my $driver = Data::Model::Driver::DBI->new(
        dsn => 'dbi:SQLite:'
    );
    for my $model ($dm->schema_names) {
        $dm->set_driver($model, $driver);
    }
}

# schema のセットアップ
for my $target ($dm->schema_names) {
    my $dbh = $dm->get_driver($target)->rw_handle;
    for my $sql ($dm->as_sqls($target)) {
        $dbh->do($sql);
    }
}

# INSERT 文の発行
$dm->set( 'user' => {
    name => 'yappo'
});
$dm->set('user' => {
    name => 'ukonmanaho'
});

# SELECT 文の発行
#  スカラコンテキストのときはイテレータ
{
    my $iterator = $dm->get('user' => {
        order => {'id' => 'ASC'}
    });
    my @names;
    while (my $row = $iterator->next) {
        push @names, $row->name;
    }
    is join(',', @names), 'yappo,ukonmanaho';
}

# リストコンテキストのときは配列
{
    my @users = $dm->get('user' => {order => { 'id' => 'DESC' }});
    is scalar(@users), 2;
    is $users[0]->name, 'ukonmanaho';
    is $users[1]->name, 'yappo';
}

# 条件つきで検索
{
    my @users = $dm->get('user' => {
        where => [
            name => 'yappo'
        ],
    });
    is scalar(@users), 1;
    is $users[0]->name, 'yappo';
}

# update
{
    my ($ukon, ) = $dm->get('user' => {
        where => [
            name => 'ukonmanaho'
        ],
    });
    is $ukon->name, 'ukonmanaho';
    $ukon->name('jack');
    $ukon->update;
}

# delete
{
    my $count_users = sub {
        scalar(my @users = $dm->get('user'));
    };

    is $count_users->(), 2;

    my ($jack, ) = $dm->get('user' => {
        where => [
            name => 'jack'
        ],
    });
    is $jack->name, 'jack';
    $jack->delete;

    is $count_users->(), 1;
}
