use strict;
use warnings;
use Neko::DB::User;
use Data::Model::Driver::DBI;

my $dm = Neko::DB::User->new();

do {
    # ドライバ情報をつっこみまくる
    my $driver = Data::Model::Driver::DBI->new(
        dsn => 'dbi:SQLite:'
    );
    $dm->set_base_driver($driver);
};

for my $target ($dm->schema_names) {
    for my $sql ($dm->as_sqls($target)) {
        print "$sql\n";
    }
}
