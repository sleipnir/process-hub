defprotocol ProcessHub.Strategy.Redundancy.Base do
  @moduledoc """
  The redundancy protocol relies on the `HashRing` library to distribute processes across
  the cluster and determine which node should be responsible for a given process by its `child_id` key.

  It is possible to start the same process on multiple nodes in the cluster.
  """

  @doc """
  Triggered when coordinator is initialized.

  Could be used to perform initialization.
  """
  @spec init(struct(), ProcessHub.hub_id()) :: any()
  def init(strategy, hub_id)

  @doc """
  Returns the replication factor for the given strategy struct. This is the number of replicas
  that the process will be started with.
  """
  @spec replication_factor(struct()) :: pos_integer()
  def replication_factor(strategy)

  @doc """
  Returns the master node that the given `child_id` belongs to.
  """
  @spec master_node(struct(), ProcessHub.hub_id(), ProcessHub.child_id(), [node()]) :: node()
  def master_node(strategy, hub_id, child_id, child_nodes)

  @doc """
  This function is called when `ProcessHub.DistributedSupervisor` has started a new
  child process, and the strategy can perform any post-start actions.
  """
  @spec handle_post_start(struct(), ProcessHub.hub_id(), [
          {ProcessHub.child_id(), pid(), [node()]}
        ]) ::
          :ok
  def handle_post_start(strategy, hub_id, processes_data)

  @doc """
  This function is called when `ProcessHub.DistributedSupervisor` has started a
  replica of a child process, and the strategy can perform any post-update actions.
  """
  @spec handle_post_update(
          struct(),
          ProcessHub.hub_id(),
          [{ProcessHub.child_id(), [node()], keyword()}],
          {:up | :down, node()}
        ) :: :ok
  def handle_post_update(strategy, hub_id, processes_data, action_node)
end
