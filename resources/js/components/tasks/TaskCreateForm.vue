<script setup lang="ts">
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { store } from '@/routes/tasks';
import { useForm } from '@inertiajs/vue3';
import { Plus } from 'lucide-vue-next';

const form = useForm({
    title: '',
});

const submit = () => {
    form.submit(store(), {
        preserveScroll: true,
        onSuccess: () => form.reset(),
    });
};
</script>

<template>
    <form class="flex gap-2" @submit.prevent="submit">
        <Input v-model="form.title" placeholder="Add a new task..." :disabled="form.processing" />

        <Button type="submit" :disabled="form.processing">
            <Plus class="mr-2 h-4 w-4" />
            Add
        </Button>
    </form>
</template>
