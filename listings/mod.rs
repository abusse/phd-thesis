unsafe extern "C" fn rust_pipe_update(_self: *mut fw_component_inst_t, 
									  _pipe: *mut fw_pipe_t) {
	let ref private = *((*_self).inst_data as *mut RustyPrivate);

	rust_lock_pipe((*private).input);

	let start = (*private.input).tasks_changed.next;
	let mut current = start;
	while (*current).next != start {
		
		let ref mut task = *((current as *mut u8).offset(private.c_offset) as *mut fw_task_t);
		
		match task.pipe_pcb[(*private.input).id as usize].change_type {
			fw_pipe_change::ADDED => {fw_pipe_add(private.output, task)}, 
			fw_pipe_change::REMOVED => {fw_pipe_remove(private.output, task)},
			fw_pipe_change::UNDEF => {}
		}
		
		current = (*current).next;		
	}

	fw_pipe_clean(private.input);

	rust_unlock_pipe(private.input);
	
	(*(*private.output).out).ops.pipe_update.unwrap()((*private.output).out, private.output);
}