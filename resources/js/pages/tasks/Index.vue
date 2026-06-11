<script setup lang="ts">
import AppLayout from '@/layouts/AppLayout.vue';
import type { BreadcrumbItem } from '@/types';

import { Badge } from '@/components/ui/badge';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';

import { Separator } from '@/components/ui/separator';

import TaskCreateForm from '@/components/tasks/TaskCreateForm.vue';
import TaskEditDialog from '@/components/tasks/TaskEditDialog.vue';
import TaskItem from '@/components/tasks/TaskItem.vue';

import { Head, useForm } from '@inertiajs/vue3';
import { ClipboardList } from 'lucide-vue-next';
import { computed, ref } from 'vue';
import { destroy } from '@/routes/tasks';

interface Task {
    id: number;
    title: string;
    is_completed: boolean;
}

const props = defineProps<{
    tasks: Task[];
}>();

const breadcrumbs: BreadcrumbItem[] = [
    {
        title: 'Tasks',
        href: '/tasks',
    },
];

const selectedTask = ref<Task | null>(null);
const dialogOpen = ref(false);

const openEdit = (task: Task) => {
    selectedTask.value = task;
    dialogOpen.value = true;
};

const remove = (task: Task) => {
    useForm().submit(destroy(task), {
        preserveScroll: true,
        onSuccess: close,
    });
};

const remaining = computed(() => props.tasks.filter((task) => !task.is_completed).length);

const doneCount = computed(() => props.tasks.filter((task) => task.is_completed).length);

const progress = computed(() => (props.tasks.length ? Math.round((doneCount.value / props.tasks.length) * 100) : 0));
</script>

<template>
    <Head title="Tasks" />

    <AppLayout :breadcrumbs="breadcrumbs">
        <div class="mx-auto flex w-full max-w-2xl flex-col gap-6 p-6">
            <Card>
                <CardHeader>
                    <div class="flex items-start justify-between">
                        <div>
                            <CardTitle> My Tasks </CardTitle>

                            <CardDescription>
                                {{ remaining }}
                                remaining
                            </CardDescription>
                        </div>

                        <div class="flex gap-2">
                            <Badge variant="secondary">
                                {{ doneCount }}
                                done
                            </Badge>

                            <Badge>
                                {{ remaining }}
                                left
                            </Badge>
                        </div>
                    </div>

                    <div v-if="tasks.length" class="mt-4 h-2 overflow-hidden rounded-full bg-muted">
                        <div
                            class="h-full bg-primary transition-all"
                            :style="{
                                width: `${progress}%`,
                            }"
                        />
                    </div>
                </CardHeader>

                <CardContent class="space-y-4">
                    <TaskCreateForm />

                    <Separator v-if="tasks.length" />

                    <ul v-if="tasks.length" class="space-y-2">
                        <TaskItem v-for="task in tasks" :key="task.id" :task="task" @edit="openEdit" @destroy="remove" />
                    </ul>

                    <div v-else class="flex flex-col items-center gap-3 py-12 text-muted-foreground">
                        <ClipboardList class="h-10 w-10 opacity-30" />

                        <p>No tasks yet — add your first task.</p>
                    </div>
                </CardContent>
            </Card>

            <TaskEditDialog v-model:open="dialogOpen" :task="selectedTask" />
        </div>
    </AppLayout>
</template>
