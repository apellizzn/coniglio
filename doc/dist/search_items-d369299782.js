searchNodes=[{"ref":"Coniglio.html","title":"Coniglio","type":"module","doc":"Coniglio"},{"ref":"Coniglio.Context.html","title":"Coniglio.Context","type":"module","doc":"Coniglio.Context"},{"ref":"Coniglio.Context.html#from_amqp_meta/1","title":"Coniglio.Context.from_amqp_meta/1","type":"function","doc":""},{"ref":"Coniglio.Delivery.html","title":"Coniglio.Delivery","type":"module","doc":"Coniglio.Delivery This module rappresent the message processed by Coniglio.Listener.t()"},{"ref":"Coniglio.Delivery.html#from_amqp_delivery/2","title":"Coniglio.Delivery.from_amqp_delivery/2","type":"function","doc":"Builds a Coniglio.Delivery.t() from an amqp delivery"},{"ref":"Coniglio.Delivery.html#from_response/3","title":"Coniglio.Delivery.from_response/3","type":"function","doc":"Builds a Coniglio.Delivery.t() from a Rabbitmq response"},{"ref":"Coniglio.Listener.html","title":"Coniglio.Listener","type":"module","doc":""},{"ref":"Coniglio.RabbitClient.Client.html","title":"Coniglio.RabbitClient.Client","type":"module","doc":"Coniglio.RabbitClient.Client This module is used to comunicate with a Rabbitmq instance"},{"ref":"Coniglio.RabbitClient.DirectReceiver.html","title":"Coniglio.RabbitClient.DirectReceiver","type":"module","doc":"Coniglio.RabbitClient.DirectReceiver This module is responsible of collecting messages on the direct reply to queue and forwording them to the waiting process"},{"ref":"Coniglio.RabbitClient.DirectReceiver.html#child_spec/1","title":"Coniglio.RabbitClient.DirectReceiver.child_spec/1","type":"function","doc":"Returns a specification to start this module under a supervisor. See Supervisor."},{"ref":"Coniglio.RabbitClient.DirectReceiver.html#init/1","title":"Coniglio.RabbitClient.DirectReceiver.init/1","type":"function","doc":"Invoked when the server is started. start_link/3 or start/3 will block until it returns. init_arg is the argument term (second argument) passed to start_link/3. Returning {:ok, state} will cause start_link/3 to return {:ok, pid} and the process to enter its loop. Returning {:ok, state, timeout} is similar to {:ok, state}, except that it also sets a timeout. See the &quot;Timeouts&quot; section in the module documentation for more information. Returning {:ok, state, :hibernate} is similar to {:ok, state} except the process is hibernated before entering the loop. See c:handle_call/3 for more information on hibernation. Returning {:ok, state, {:continue, continue}} is similar to {:ok, state} except that immediately after entering the loop the c:handle_continue/2 callback will be invoked with the value continue as first argument. Returning :ignore will cause start_link/3 to return :ignore and the process will exit normally without entering the loop or calling c:terminate/2. If used when part of a supervision tree the parent supervisor will not fail to start nor immediately try to restart the GenServer. The remainder of the supervision tree will be started and so the GenServer should not be required by other processes. It can be started later with Supervisor.restart_child/2 as the child specification is saved in the parent supervisor. The main use cases for this are: The GenServer is disabled by configuration but might be enabled later. An error occurred and it will be handled by a different mechanism than the Supervisor. Likely this approach involves calling Supervisor.restart_child/2 after a delay to attempt a restart. Returning {:stop, reason} will cause start_link/3 to return {:error, reason} and the process to exit with reason reason without entering the loop or calling c:terminate/2. Callback implementation for GenServer.init/1."},{"ref":"Coniglio.RabbitClient.DirectReceiver.html#start_link/1","title":"Coniglio.RabbitClient.DirectReceiver.start_link/1","type":"function","doc":""},{"ref":"Coniglio.RabbitClient.RealClient.html","title":"Coniglio.RabbitClient.RealClient","type":"module","doc":""},{"ref":"Coniglio.RabbitClient.RealClient.html#bind_exchange/3","title":"Coniglio.RabbitClient.RealClient.bind_exchange/3","type":"function","doc":"Creates a queue and binds it to an exchange wait for the response"},{"ref":"Coniglio.RabbitClient.RealClient.html#child_spec/1","title":"Coniglio.RabbitClient.RealClient.child_spec/1","type":"function","doc":"Returns a specification to start this module under a supervisor. See Supervisor."},{"ref":"Coniglio.RabbitClient.RealClient.html#get/0","title":"Coniglio.RabbitClient.RealClient.get/0","type":"function","doc":"Get the client configuraion"},{"ref":"Coniglio.RabbitClient.RealClient.html#init/1","title":"Coniglio.RabbitClient.RealClient.init/1","type":"function","doc":"Invoked when the server is started. start_link/3 or start/3 will block until it returns. init_arg is the argument term (second argument) passed to start_link/3. Returning {:ok, state} will cause start_link/3 to return {:ok, pid} and the process to enter its loop. Returning {:ok, state, timeout} is similar to {:ok, state}, except that it also sets a timeout. See the &quot;Timeouts&quot; section in the module documentation for more information. Returning {:ok, state, :hibernate} is similar to {:ok, state} except the process is hibernated before entering the loop. See c:handle_call/3 for more information on hibernation. Returning {:ok, state, {:continue, continue}} is similar to {:ok, state} except that immediately after entering the loop the c:handle_continue/2 callback will be invoked with the value continue as first argument. Returning :ignore will cause start_link/3 to return :ignore and the process will exit normally without entering the loop or calling c:terminate/2. If used when part of a supervision tree the parent supervisor will not fail to start nor immediately try to restart the GenServer. The remainder of the supervision tree will be started and so the GenServer should not be required by other processes. It can be started later with Supervisor.restart_child/2 as the child specification is saved in the parent supervisor. The main use cases for this are: The GenServer is disabled by configuration but might be enabled later. An error occurred and it will be handled by a different mechanism than the Supervisor. Likely this approach involves calling Supervisor.restart_child/2 after a delay to attempt a restart. Returning {:stop, reason} will cause start_link/3 to return {:error, reason} and the process to exit with reason reason without entering the loop or calling c:terminate/2. Callback implementation for GenServer.init/1."},{"ref":"Coniglio.RabbitClient.RealClient.html#publish/2","title":"Coniglio.RabbitClient.RealClient.publish/2","type":"function","doc":"Fire and forget action, publish a message to an exchange + topic"},{"ref":"Coniglio.RabbitClient.RealClient.html#register_consumer/2","title":"Coniglio.RabbitClient.RealClient.register_consumer/2","type":"function","doc":""},{"ref":"Coniglio.RabbitClient.RealClient.html#request/2","title":"Coniglio.RabbitClient.RealClient.request/2","type":"function","doc":"Request / Response action, publish a message to an exchange + topic and wait for the response"},{"ref":"Coniglio.RabbitClient.RealClient.html#start_link/1","title":"Coniglio.RabbitClient.RealClient.start_link/1","type":"function","doc":""},{"ref":"Coniglio.RabbitClient.RealClient.html#stop/0","title":"Coniglio.RabbitClient.RealClient.stop/0","type":"function","doc":"Stops the client by closing its connection to the Rabbitmq instance"},{"ref":"Coniglio.Service.html","title":"Coniglio.Service","type":"module","doc":"Coniglio.Service This module is used to register a service and a list of listeners"},{"ref":"Coniglio.Service.html#child_spec/1","title":"Coniglio.Service.child_spec/1","type":"function","doc":"Returns a specification to start this module under a supervisor. See Supervisor."},{"ref":"Coniglio.Service.html#init/1","title":"Coniglio.Service.init/1","type":"function","doc":"Callback invoked to start the supervisor and during hot code upgrades. Developers typically invoke Supervisor.init/2 at the end of their init callback to return the proper supervision flags. Callback implementation for Supervisor.init/1."},{"ref":"Coniglio.Service.html#start_link/1","title":"Coniglio.Service.start_link/1","type":"function","doc":""},{"ref":"DirectReceiver.html","title":"DirectReceiver","type":"module","doc":""},{"ref":"DirectReceiver.html#child_spec/1","title":"DirectReceiver.child_spec/1","type":"function","doc":"Returns a specification to start this module under a supervisor. See Supervisor."},{"ref":"DirectReceiver.html#init/1","title":"DirectReceiver.init/1","type":"function","doc":"Invoked when the server is started. start_link/3 or start/3 will block until it returns. init_arg is the argument term (second argument) passed to start_link/3. Returning {:ok, state} will cause start_link/3 to return {:ok, pid} and the process to enter its loop. Returning {:ok, state, timeout} is similar to {:ok, state}, except that it also sets a timeout. See the &quot;Timeouts&quot; section in the module documentation for more information. Returning {:ok, state, :hibernate} is similar to {:ok, state} except the process is hibernated before entering the loop. See c:handle_call/3 for more information on hibernation. Returning {:ok, state, {:continue, continue}} is similar to {:ok, state} except that immediately after entering the loop the c:handle_continue/2 callback will be invoked with the value continue as first argument. Returning :ignore will cause start_link/3 to return :ignore and the process will exit normally without entering the loop or calling c:terminate/2. If used when part of a supervision tree the parent supervisor will not fail to start nor immediately try to restart the GenServer. The remainder of the supervision tree will be started and so the GenServer should not be required by other processes. It can be started later with Supervisor.restart_child/2 as the child specification is saved in the parent supervisor. The main use cases for this are: The GenServer is disabled by configuration but might be enabled later. An error occurred and it will be handled by a different mechanism than the Supervisor. Likely this approach involves calling Supervisor.restart_child/2 after a delay to attempt a restart. Returning {:stop, reason} will cause start_link/3 to return {:error, reason} and the process to exit with reason reason without entering the loop or calling c:terminate/2. Callback implementation for GenServer.init/1."},{"ref":"DirectReceiver.html#start_link/1","title":"DirectReceiver.start_link/1","type":"function","doc":""},{"ref":"Main.html","title":"Main","type":"module","doc":""},{"ref":"Main.html#try/0","title":"Main.try/0","type":"function","doc":""},{"ref":"Message.html","title":"Message","type":"module","doc":"Message"},{"ref":"Message.html#decode/1","title":"Message.decode/1","type":"function","doc":""},{"ref":"Message.html#encode/1","title":"Message.encode/1","type":"function","doc":""},{"ref":"Message.html#new/1","title":"Message.new/1","type":"function","doc":""},{"ref":"Message.html#t:t/0","title":"Message.t/0","type":"type","doc":""},{"ref":"SayHi.html","title":"SayHi","type":"behaviour","doc":""},{"ref":"SayHi.html#child_spec/1","title":"SayHi.child_spec/1","type":"function","doc":"Returns a specification to start this module under a supervisor. See Supervisor."},{"ref":"SayHi.html#exchange/0","title":"SayHi.exchange/0","type":"function","doc":""},{"ref":"SayHi.html#c:exchange/0","title":"SayHi.exchange/0","type":"callback","doc":""},{"ref":"SayHi.html#handle/1","title":"SayHi.handle/1","type":"function","doc":""},{"ref":"SayHi.html#c:handle/1","title":"SayHi.handle/1","type":"callback","doc":""},{"ref":"SayHi.html#init/1","title":"SayHi.init/1","type":"function","doc":"Invoked when the server is started. start_link/3 or start/3 will block until it returns. init_arg is the argument term (second argument) passed to start_link/3. Returning {:ok, state} will cause start_link/3 to return {:ok, pid} and the process to enter its loop. Returning {:ok, state, timeout} is similar to {:ok, state}, except that it also sets a timeout. See the &quot;Timeouts&quot; section in the module documentation for more information. Returning {:ok, state, :hibernate} is similar to {:ok, state} except the process is hibernated before entering the loop. See c:handle_call/3 for more information on hibernation. Returning {:ok, state, {:continue, continue}} is similar to {:ok, state} except that immediately after entering the loop the c:handle_continue/2 callback will be invoked with the value continue as first argument. Returning :ignore will cause start_link/3 to return :ignore and the process will exit normally without entering the loop or calling c:terminate/2. If used when part of a supervision tree the parent supervisor will not fail to start nor immediately try to restart the GenServer. The remainder of the supervision tree will be started and so the GenServer should not be required by other processes. It can be started later with Supervisor.restart_child/2 as the child specification is saved in the parent supervisor. The main use cases for this are: The GenServer is disabled by configuration but might be enabled later. An error occurred and it will be handled by a different mechanism than the Supervisor. Likely this approach involves calling Supervisor.restart_child/2 after a delay to attempt a restart. Returning {:stop, reason} will cause start_link/3 to return {:error, reason} and the process to exit with reason reason without entering the loop or calling c:terminate/2. Callback implementation for GenServer.init/1."},{"ref":"SayHi.html#reply/2","title":"SayHi.reply/2","type":"function","doc":""},{"ref":"SayHi.html#start_link/1","title":"SayHi.start_link/1","type":"function","doc":""},{"ref":"SayHi.html#topic/0","title":"SayHi.topic/0","type":"function","doc":""},{"ref":"SayHi.html#c:topic/0","title":"SayHi.topic/0","type":"callback","doc":""},{"ref":"readme.html","title":"Coniglio","type":"extras","doc":"Coniglio TODO: Add description"},{"ref":"readme.html#installation","title":"Coniglio - Installation","type":"extras","doc":"If available in Hex, the package can be installed by adding coniglio to your list of dependencies in mix.exs: def deps do [ {:coniglio, &quot;~&gt; 0.1.0&quot;} ] end Documentation can be generated with ExDoc and published on HexDocs. Once published, the docs can be found at https://hexdocs.pm/coniglio."}]