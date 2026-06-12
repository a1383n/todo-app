<script setup lang="ts">
import { Dialog, DialogContent, DialogDescription, DialogFooter, DialogHeader, DialogTitle } from '@/components/ui/dialog';

import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';

import { useForm } from '@inertiajs/vue3';
import { watch } from 'vue';

interface Task {
    id: number;
    title: string;
    is_completed: boolean;
}

const props = defineProps<{
    open: boolean;
    task: Task | null;
}>();

const emit = defineEmits<{
    'update:open': [value: boolean];
}>();

const form = useForm({
    title: '',
});

watch(
    () => props.task,
    (task) => {
        form.title = task?.title ?? '';
    },
    { immediate: true },
);

const close = () => {
    emit('update:open', false);
};

const submit = () => {
    if (!props.task) return;

    form.submit(update(props.task), {
        preserveScroll: true,
        onSuccess: close,
    });
};
</script>

<template>
    <Dialog :open="open" @update:open="emit('update:open', $event)">
        <DialogContent>
            <DialogHeader>
                <DialogTitle> Edit Task </DialogTitle>

                <DialogDescription> Update or delete this task. </DialogDescription>
            </DialogHeader>

            <Input v-model="form.title" placeholder="Task title" />

            <DialogFooter class="justify-between">
                <Button :disabled="form.processing" @click="submit">Save</Button>
            </DialogFooter>
        </DialogContent>
    </Dialog>
</template>
