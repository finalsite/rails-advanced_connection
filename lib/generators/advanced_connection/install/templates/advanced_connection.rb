#
# Advanced Connection Configuration
#
AdvancedConnection.configure do |config|
  #
  ## Idle Manager
  #
  # Enabling this will enable idle connection management. This allows you to specify settings
  # to enable the automatic reaping of idle database connections.
  #
  # config.enable_idle_connection_manager = <%= AdvancedConnection::Config::DEFAULT_CONFIG.enable_idle_connection_manager.inspect %>

  # Pool queue type determines both how free connections will be checkout out
  # of the pool, as well as how idle connections will be reaped. The options are:
  #
  #  :fifo           - All connections will have an equal opportunity to be used and reaped (default)
  #  :lifo/:stack    - More frequently used connections will be reused, leaving less frequently used
  #                    connections to be reaped
  #  :prefer_older   - Longer lived connections will tend to stick around longer, with younger
  #                    connections being reaped
  #  :prefer_younger - Younger lived connections will tend to stick around longer, with older
  #                    connections being reaped
  #
  # config.connection_pool_queue_type     = <%= AdvancedConnection::Config::DEFAULT_CONFIG.connection_pool_queue_type.inspect %>

  # What log level to log idle manager stats and details at (see ::Logger#level)
  # config.idle_manager_log_level = ::Logger::INFO

  # Maximum number of connections that can remain idle without being reaped. If you have
  # more idle conections than this, only the difference between the total idle and this
  # maximum will be reaped.
  #
  # config.max_idle_connections           = ::Float::INFINITY

  # How long (in seconds) a connection can remain idle before being reaped
  #
  # config.max_idle_time                  = 90

  # How many seconds between idle checks (defaults to max_idle_time)
  #
  # config.idle_check_interval            = 90

  #
  ## Without Connection
  #
  # Enabling this will add a new method to ActiveRecord::Base that allows you to
  # mark a block of code as not requiring a connection. This can be useful in reducing
  # pressure on the pool, especially when you have sections of code that make
  # potentially long-lived external requests. E.g.,
  #
  # require 'open-uri'
  # results = ActiveRecord::Base.without_connection do
  #   open('http://some-slow-site.com/api/foo')
  # end
  #
  # During the call to the remote site, the db connection is checked in and subsequently
  # checked back out once the block finishes.
  #
  # To enable this feature, uncomment the following:
  #
  # config.enable_without_connection = true
  #
  # WARNING: this feature cannot be enabled with Statement Pooling.
  #
  # Additionally, you can hook into the checkin / chekcout lifecycle by way of callbacks. This
  # can be extremely useful when employing something like Apartment to manage switching
  # between tenants.
  #
  # config.without_connection_callbacks = {
  #   # runs right before the connection is checked back into the pool
  #   before:  ->() { },
  #   around:  ->(&block) {
  #     tenant = Apartment::Tenant.current
  #     block.call
  #     Apartment::Tenant.switch(tenant)
  #   },
  #   # runs right after the connection is checked back out of the pool
  #   after:  ->() { }
  # }
  #
  ## Statement Pooling
  #
  # **** WARNING **** EXPERIMENTAL **** WARNING **** EXPERIMENTAL ****
  #
  # THIS FEATURE IS HIGHLY EXPERIMENTAL AND PRONE TO FAILURE. DO NOT USE UNLESS
  # YOU PLAN TO AIDE IN IT'S DEVELOPMENT.
  #
  # When enabled, this feature causes your connections to immediately be returned to
  # the pool upon completion of each query (with the exception of transactions, where
  # the connection is returned after transaction commit/rollback). This can help to
  # reduce pressure on the pool, as well as the number of the connections to the
  # backend by making more efficient use of existing connections.
  #
  # WARNING: this cannot be enabled with Without Connection.
  #
  # To enable, simply uncomment the following:
  #
  # config.enable_statement_pooling = true
  #
  # Additionally, callbacks are provided around the connection checkin. This can
  # be extremely useful when in a multi-tenant situation using something like
  # Apartment, e.g.:
  #
  # lib/apartment/elevators/my_elevator.rb:
  # module Apartment::Elevators
  #   class MyElevator < Generic
  #     def call(env)
  #       super
  #     ensure
  #       Thread.current[:tenant] = nil
  #       Apartment::Tenant.reset
  #     end
  #
  #     def parse_tenant_name(request)
  #       request.host.split('.').first.tap do |tenant|
  #         Thread.current[:tenant] = tenant
  #       end
  #     end
  #   end
  #   . . .
  # end
  #
  # and then set your statement_pooling_callbacks like so:
  #
  # config.statement_pooling_callbacks = {
  #   # switch back to the stored tenant prior to executing sql
  #   before:  ->() {
  #     if Thread.current[:tenant]
  #       Apartment::Tenant.switch(Thread.current[:tenant])
  #     end
  #   }
  # }
end
