class Object  
  def raise_with_chuck_norris(*args)
    exception = args.first
    # Only Rubinius catches SystemExit at the end. Ignore it
    unless exception.is_a?(SystemExit)
      $stdout.puts("Chuck Norris has thrown #{args.first} and has given quarter to your app")
      say "Boom"
    end
    
    raise_without_chuck_norris(*args)
  end
  
  alias raise_without_chuck_norris raise
  alias raise raise_with_chuck_norris

  private
  
  def chuck_norris_pays_last_respects
    $stdout.puts("Chuck Norris pays last respects to your app...")
    say "Rest in Peace"
  end
  
  def say(text)
    `say #{text} &` if RUBY_PLATFORM =~ /darwin/
  end
end

# LITTLE HACK to put Chuck Norris last respects at the end of application lifetime.
# Kernel runs exit procs in reverse mode and at this point we can already have
# other exit procs. For example from Shoulda or UnitTest (I'm not sure which exactly).

# This hack works on MRI 1.8/1.9 and REE (actually it's a bug!)
# and does not work on JRuby/Rubinius (well done!)

# But anyway, we can postone creation of last respects on MRI 1.8/1.9 and REE.

Kernel.at_exit { 
  Kernel.at_exit { chuck_norris_pays_last_respects } 
}