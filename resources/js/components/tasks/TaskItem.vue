<script setup lang="ts">
import { Button } from '@/components/ui/button';
import { Checkbox } from '@/components/ui/checkbox';
import { update } from '@/routes/tasks';
import { useForm } from '@inertiajs/vue3';
import { Pencil, Trash } from 'lucide-vue-next';

interface Task {
    id: number;
    title: string;
    is_completed: boolean;
}

const props = defineProps<{
    task: Task;
}>();

const emit = defineEmits<{
    edit: [task: Task];
    destroy: [task: Task];
}>();

const toggle = (checked: boolean) => {
    useForm({
        title: props.task.title,
        is_completed: checked,
    }).submit(update(props.task), {
        preserveScroll: true,
    });
};
</script>

<template>
    <li class="flex items-center gap-3 rounded-lg border p-3">
        <Checkbox :checked="task.is_completed" @update:checked="toggle" />

        <div class="flex-1">
            <p
                class="text-sm"
                :class="{
                    'text-muted-foreground line-through': task.is_completed,
                }"
            >
                {{ task.title }}
            </p>
        </div>

        <Button variant="default" size="icon" @click="emit('edit', task)">
            <Pencil class="h-4 w-4" />
        </Button>

        <Button variant="destructive" size="icon" @click="emit('destroy', task)">
            <Trash class="h-4 w-4" />
        </Button>
    </li>
</template>
