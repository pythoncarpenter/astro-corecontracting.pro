<template>
  <div class="space-y-8">
    <div class="bg-white dark:bg-primary-800 rounded-lg p-6">
      <h2 class="text-2xl font-display mb-4">Projects</h2>
      <draggable
        v-model="projects"
        item-key="id"
        class="space-y-4"
        @end="updateProjectOrder"
      >
        <template #item="{ element }">
          <div class="bg-primary-100 dark:bg-primary-700 p-4 rounded-lg">
            <div class="flex justify-between items-center">
              <h3 class="text-xl font-display">{{ element.title }}</h3>
              <div class="space-x-2">
                <button
                  @click="editProject(element)"
                  class="bg-wood hover:bg-wood-dark text-white px-3 py-1 rounded"
                >
                  Edit
                </button>
                <button
                  @click="deleteProject(element.id)"
                  class="bg-red-500 hover:bg-red-600 text-white px-3 py-1 rounded"
                >
                  Delete
                </button>
              </div>
            </div>
          </div>
        </template>
      </draggable>
      
      <button
        @click="showNewProjectModal = true"
        class="mt-4 bg-wood-dark hover:bg-wood text-white px-4 py-2 rounded-lg transition-colors"
      >
        Add New Project
      </button>
    </div>

    <!-- Project Modal -->
    <div v-if="showNewProjectModal || editingProject" class="fixed inset-0 bg-black/50 flex items-center justify-center z-50">
      <div class="bg-white dark:bg-primary-800 rounded-lg p-6 max-w-2xl w-full">
        <h3 class="text-2xl font-display mb-4">
          {{ editingProject ? 'Edit Project' : 'New Project' }}
        </h3>
        
        <form @submit.prevent="saveProject" class="space-y-4">
          <div>
            <label class="block text-sm font-medium mb-1">Title</label>
            <input
              v-model="projectForm.title"
              type="text"
              class="w-full px-3 py-2 border rounded-lg"
              required
            />
          </div>
          
          <div>
            <label class="block text-sm font-medium mb-1">Description</label>
            <textarea
              v-model="projectForm.description"
              class="w-full px-3 py-2 border rounded-lg"
              rows="3"
              required
            ></textarea>
          </div>
          
          <div>
            <label class="block text-sm font-medium mb-1">Images</label>
            <input
              type="file"
              @change="handleImageUpload"
              multiple
              accept="image/*"
              class="w-full"
            />
          </div>
          
          <div v-if="projectForm.images.length" class="grid grid-cols-3 gap-4">
            <div
              v-for="(image, index) in projectForm.images"
              :key="index"
              class="relative"
            >
              <img
                :src="image"
                class="w-full h-32 object-cover rounded"
              />
              <button
                @click="removeImage(index)"
                class="absolute top-2 right-2 bg-red-500 text-white rounded-full w-6 h-6"
              >
                &times;
              </button>
            </div>
          </div>
          
          <div class="flex justify-end space-x-4">
            <button
              type="button"
              @click="closeModal"
              class="px-4 py-2 border rounded-lg"
            >
              Cancel
            </button>
            <button
              type="submit"
              class="bg-wood-dark hover:bg-wood text-white px-4 py-2 rounded-lg"
            >
              Save
            </button>
          </div>
        </form>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive } from 'vue';
import draggable from 'vuedraggable';

const projects = ref([]);
const showNewProjectModal = ref(false);
const editingProject = ref(null);
const projectForm = reactive({
  title: '',
  description: '',
  images: []
});

async function loadProjects() {
  const response = await fetch('/api/projects');
  projects.value = await response.json();
}

async function handleImageUpload(event) {
  const files = Array.from(event.target.files);
  const formData = new FormData();
  
  files.forEach(file => {
    formData.append('images', file);
  });
  
  const response = await fetch('/api/upload', {
    method: 'POST',
    body: formData
  });
  
  const result = await response.json();
  projectForm.images.push(...result.urls);
}

async function saveProject() {
  const projectData = {
    title: projectForm.title,
    description: projectForm.description,
    images: projectForm.images
  };
  
  if (editingProject.value) {
    projectData.id = editingProject.value.id;
  }
  
  await fetch('/api/projects', {
    method: editingProject.value ? 'PUT' : 'POST',
    headers: {
      'Content-Type': 'application/json'
    },
    body: JSON.stringify(projectData)
  });
  
  await loadProjects();
  closeModal();
}

function closeModal() {
  showNewProjectModal.value = false;
  editingProject.value = null;
  projectForm.title = '';
  projectForm.description = '';
  projectForm.images = [];
}

function editProject(project) {
  editingProject.value = project;
  projectForm.title = project.title;
  projectForm.description = project.description;
  projectForm.images = [...project.images];
}

async function deleteProject(id) {
  if (confirm('Are you sure you want to delete this project?')) {
    await fetch(`/api/projects/${id}`, {
      method: 'DELETE'
    });
    await loadProjects();
  }
}

async function updateProjectOrder() {
  await fetch('/api/projects/order', {
    method: 'PUT',
    headers: {
      'Content-Type': 'application/json'
    },
    body: JSON.stringify(projects.value)
  });
}

loadProjects();
</script>