class Object
  def raise(*args)
    $stdout.puts("Chuck Norris has thrown #{args.first} and killed your app.") unless $!.to_s == 'exit'
    exit 0
  end
end