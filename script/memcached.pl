use strict;
use warnings;
use Test::More tests => 2;
use Neko::DB::User;
use Data::Model::Driver::Memcached;
use Cache::Memcached::Fast;

my $dm = Neko::DB::User->new();

# ドライバ情報をつっこみまくる
{
    my $driver = Data::Model::Driver::Memcached->new(
        memcached => Cache::Memcached::Fast->new({
            servers => [
                '127.0.0.1:11211',
            ],
        }),
    );
    $dm->set_base_driver($driver);
}

# INSERT
$dm->set( 'user' => 1, {
    name => 'yappo'
});
$dm->set('user' => 2, {
    name => 'ukonmanaho'
});

# SELECT
{
    my ($yappo) = $dm->get('user' => 1);
    is $yappo->name, 'yappo';
}
{
    my ($ukonmanaho) = $dm->get('user' => 2);
    is $ukonmanaho->name, 'ukonmanaho';
}
