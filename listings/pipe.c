struct fw_pipe {
	struct fw_tlist task_list;
	struct fw_tlist tasks_added;
	struct fw_tlist tasks_removed;
	struct fw_tlist tasks_moved;
	void (*pipe_update)()
};
