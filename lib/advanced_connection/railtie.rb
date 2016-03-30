#
# Copyright (C) 2016 Finalsite, LLC
# Copyright (C) 2016 Carl P. Corliss <carl.corliss@finalsite.com>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of
# this software and associated documentation files (the "Software"), to deal in
# the Software without restriction, including without limitation the rights to
# use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
# the Software, and to permit persons to whom the Software is furnished to do so,
# subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
# FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
# COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
# IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
# CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#
module AdvancedConnection
  class Railtie < Rails::Railtie
    config.advanced_connection = ActiveSupport::OrderedOptions.new

    if AdvancedConnection.can_enable?
      ActiveSupport.on_load(:before_initialize) do
        ActiveSupport.on_load(:active_record) do
          # load our intitializer ASAP so we can make use of user defined configuration
          load Rails.root.join('config', 'initializers', 'advanced_connection.rb')
          ActiveRecord::Base.send(:include, AdvancedConnection::ActiveRecordExt)
        end
      end

      config.after_initialize do
        if AdvancedConnection.enable_idle_connection_manager && AdvancedConnection.warmup_connections
          ActiveRecord::Base.connection_handler.connection_pool_list.each(&:warmup_connections)
        end
      end
    end
  end
end
