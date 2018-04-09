#ifndef TOPIC_AFFINITY_H_
#define TOPIC_AFFINITY_H_

#include <fw_cpumask.h>

#define FW_TOPIC_AFFINITY	16                 /** Topic ID */
#define FW_TUUID_AFFINITY	468608183          /** Topic UUID */
#define FW_TNAME_AFFINITY	"AFFINITY"         /** Topic Name */
#define FW_TDESC_AFFINITY	"Task Affinities"  /** Topic Description */

typedef struct fw_task fw_task_t;

typedef struct fw_affinity_msg {
	fw_task_t *task;        /**< The affected task. */
	fw_cpumask_t mask;      /**< The tasks (new) affinity. */
} fw_affinity_msg_t;

#endif /* TOPIC_AFFINITY_H_ */