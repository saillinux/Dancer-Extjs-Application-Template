package MyApp;

use Dancer ':syntax';
use Dancer::Plugin::REST;

our $VERSION  = '0.1';

# routes: services
any '/service/login.:format' => sub {
    my $vars = request->params;
    if (1) {
        my $db = Atoms::Data->new(constr('atoms'));
        return {
            success => 1,
            error => {
                reason => ''
            }
        };    
    }
    else {
        return {
            success => 0,
            error => {
                reason => 'yada'
            }
        };
    }
};

# webroot route
get '/' => sub {
    template 'index';
};

prepare_serializer_for_format();
true;
