package Neko::DB::User;
use strict;
use warnings;
use base 'Data::Model';
use Data::Model::Schema sugar => 'myapp';
use Neko::Columns;

install_model user => schema {
    # primary key
    key 'id';

    # カラム定義
    column 'user.id' => { auto_increment => 1 };
    utf8_column 'user.name';
};

1;
