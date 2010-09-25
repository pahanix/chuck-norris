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
  
  def __mri_or_ree?
    #             1.8.6               1.8.7/1.9.*, ree
    !defined?(RUBY_DESCRIPTION) || RUBY_DESCRIPTION =~ /^ruby/
  end
end

# LITTLE HACK to put Chuck Norris last respects at the end of application lifetime.
# Kernel runs exit procs in reverse mode and at this point we can already have
# other exit procs. For example from Shoulda or UnitTest (I'm not sure which exactly).

if __mri_or_ree?
  # This hack works on MRI 1.8/1.9 and REE (actually it's a bug!)
  # and does not work on JRuby/Rubinius (well done!)
  Kernel.at_exit { 
    Kernel.at_exit { chuck_norris_pays_last_respects } 
  }
elsif defined? Rubinius::AtExit
  # Chuck Norris can hack even Rubinius
  #
  # Rubinius Kernel.at_exit implementation looks
  #
  # def at_exit(&block)
  #   Rubinius::AtExit.unshift(block)
  # end
  #
  # We break incapsulation here and change internals of Rubunius
  # We invert usual #at_exit and change Rubinius::AtExit directly
  #
  Rubinius::AtExit.push(lambda { chuck_norris_pays_last_respects })
elsif RUBY_PLATFORM =~ /java/
  # and Java knocks under Chuck Norris
  require 'java'
  org.jruby.Ruby.getGlobalRuntime.pushExitBlock(lambda { chuck_norris_pays_last_respects })
end