static void hq_pipe_update(fw_component_inst_t *self, fw_pipe_t *pipe)
{
	fw_task_t *pos, *n;
	hq_private_data_t *pd = inst_data(hq_private_data_t);

	fw_spin_lock(&pipe->lock);

	fw_list_for_each_entry_safe(pos, n, (&pipe->tasks_changed), 
								pipe_pcb[pipe->id].changed) {
		switch (pos->pipe_pcb[pipe->id].change_type) {
			case ADDED:
				fw_pipe_add(pd->out_pipe, pos);
				break;
			case REMOVED:
				fw_pipe_remove(pd->out_pipe, pos);
				break;
			default:
				break;
		}
	}

	fw_pipe_clean(pipe);

	fw_spin_unlock(&pipe->lock);

	pd->out_pipe->out->ops.pipe_update(pd->out_pipe->out, pd->out_pipe);
}