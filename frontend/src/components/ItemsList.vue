<template>
  <v-data-table :headers="headers" :items="items" sort-by="title" class="elevation-1">
    <template v-slot:top>
      <v-toolbar flat color="white">
        <v-toolbar-title>List items</v-toolbar-title>
        <v-divider class="mx-4" inset vertical></v-divider>
        <v-spacer></v-spacer>
        <v-dialog v-model="dialog" max-width="500px">
          <template v-slot:activator="{ on }">
            <div v-if="isLoggedIn">
              <v-btn color="primary" dark class="mb-2" v-on="on">New Item</v-btn>
            </div>
          </template>
          <v-card>
            <v-card-title>
              <span class="headline">{{ formTitle }}</span>
            </v-card-title>
            <v-card-text>
              <v-container>
                <v-row>
                  <v-col cols="12" sm="6" md="12">
                    <v-text-field v-model="editedItem.name" label="Name"></v-text-field>
                  </v-col>
                  <v-col cols="12" sm="12" md="12">
                    <v-text-field v-model="editedItem.completion_status" label="Completion status"></v-text-field>
                  </v-col>
                  <v-col cols="12" sm="6" md="12">
                    <v-text-field v-model="editedItem.description" label="Description"></v-text-field>
                  </v-col>
                </v-row>
              </v-container>
            </v-card-text>
            <v-card-actions>
              <v-spacer></v-spacer>
              <v-btn color="blue darken-1" text @click="close">Cancel</v-btn>
              <v-btn color="blue darken-1" text @click="save(editedItem)">Save</v-btn>
            </v-card-actions>
          </v-card>
        </v-dialog>
        <v-dialog v-model="showDialog" max-width="500px">
          <v-card>
            <v-card-title>
              <span class="headline">{{ "Show item" }}</span>
            </v-card-title>
            <v-card-text>
              <v-container>
                <v-row>
                  <v-col cols="12" sm="6" md="12">
                    <v-text-field readonly v-model="item.name" label="Name"></v-text-field>
                  </v-col>
                  <v-col cols="12" sm="12" md="12">
                    <v-text-field readonly v-model="item.completion_status" label="Completion status"></v-text-field>
                  </v-col>
                  <v-col cols="12" sm="6" md="12">
                    <v-text-field readonly v-model="item.description" label="Description"></v-text-field>
                  </v-col>
                  <v-col cols="12" sm="6" md="12">
                    <v-text-field readonly v-model="item.list_id" label="List id"></v-text-field>
                  </v-col>
                </v-row>
              </v-container>
            </v-card-text>
            <v-card-actions>
              <v-spacer></v-spacer>
              <v-btn color="blue darken-1" text @click="closeShowDialog">Cancel</v-btn>
            </v-card-actions>
          </v-card>
        </v-dialog>
      </v-toolbar>
    </template>
    <template v-slot:item.action="{ item }">
      <div v-if="isLoggedIn">
        <v-icon small class="mr-2" @click="getItem(item)">mdi-arrow-up-bold-box-outline</v-icon>
        <v-icon small class="mr-2" @click="editItem(item)">edit</v-icon>
        <v-icon small @click="deleteItem(item)">delete</v-icon>
      </div>
    </template>
    <template v-slot:no-data>
      <v-btn color="primary" @click="initialize">Reset</v-btn>
    </template>
  </v-data-table>

</template>

<script>
import axios from "axios";
import {mapGetters} from "vuex";
export default {
  data: () => ({
    dialog: false,
    showDialog: false,
    headers: [
      {
        text: "Name",
        align: "left",
        sortable: false,
        value: "name"
      },
      { text: "Completion status", value: "completion_status" },
      { text: "Description", value: "description" },
      { text: "List id", value: "list_id" },
      { text: "Actions", value: "action", sortable: false }
    ],
    items: [],
    editedIndex: -1,
    editedItem: {
      name: "",
      completion_status: "",
      description: "",
      list_id: ""
    },
    defaultItem: {
      name: "",
      completion_status: "",
      description: "",
      list_id: ""
    },
    item: [],
    listId: null
  }),
  computed: {
    ...mapGetters(["isLoggedIn"]),
    formTitle() {
      return this.editedIndex === -1 ? "New Item" : "Edit Item";
    }
  },
  watch: {
    dialog(val) {
      val || this.close();
    }
  },
  created() {
    this.listId = this.$route.params.listId;
    this.initialize();
  },
  methods: {
    initialize() {
      const config = {
        headers: {
          authorization: localStorage.auth_token,
        },
      };
      return axios
          .get(`http://localhost:3000/items?list_id=${this.listId}`, config)
          .then(response => {
            console.log(response.data);
            this.items = response.data;
          })
          .catch(e => {
            console.log(e);
          });
    },
    editItem(item) {
      this.editedIndex = item.id;
      this.editedItem = Object.assign({}, item);
      this.dialog = true;
    },
    deleteItem(item) {
      const index = this.items.indexOf(item);
      confirm("Are you sure you want to delete this item?");
      const config = {
        headers: {
          authorization: localStorage.auth_token,
        },
      };
      axios
          .delete(`http://localhost:3000/items/${item.id}`, config)
          .then(response => {
            console.log(response);
            console.log(response.data.json);
            alert("Record was successfully removed");
            this.initialize();
          })
          .catch(error => {
            console.log(error);
          });
      this.items.splice(index, 1);
    },
    close() {
      this.dialog = false;
      setTimeout(() => {
        this.editedItem = Object.assign({}, this.defaultItem);
        this.editedIndex = -1;
      }, 300);
    },
    closeShowDialog() {
      this.showDialog = false;
    },
    save(item) {
      const config = {
        headers: {
          authorization: localStorage.auth_token,
        },
      };
      if (this.editedIndex > -1) {
        axios
            .put(`http://localhost:3000/items/${item.id}`, {
              name: this.editedItem.name,
              completion_status: this.editedItem.completion_status,
              description: this.editedItem.description,
              list_id: this.listId
            }, config)
            .then(response => {
              console.log(response);
              this.initialize();
            })
            .catch(error => {
              console.log(error);
            });
      } else {
        console.log(item);
        this.editedItem.list_id = this.listId
        axios
            .post(`http://localhost:3000/items/`, {
              item: this.editedItem
            }, config)
            .then(response => {
              console.log(response);
              console.log("Created!");
              this.initialize();
            })
            .catch(error => {
              console.log(error);
            });
        this.items.push(this.editedItem);
      }
      this.close();
    },
    getItem(item) {
      const config = {
        headers: {
          authorization: localStorage.auth_token,
        },
      };
      axios
          .get(`http://localhost:3000/items/${item.id}`, config)
          .then(response => {
            console.log(response.data);
            this.item = response.data;
          })
          .catch(error => {
            console.log(error);
          });
      this.showDialog = true;
    }
  }
};
</script>