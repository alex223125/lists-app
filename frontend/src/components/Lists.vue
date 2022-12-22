<template>
  <v-data-table
      :headers="headers"
      :items="lists"
      sort-by="title"
      class="elevation-1"
      :footer-props="{
        showFirstLastPage: true,
        firstIcon: 'mdi-arrow-collapse-left',
        lastIcon: 'mdi-arrow-collapse-right',
        prevIcon: 'mdi-minus',
        nextIcon: 'mdi-plus'
      }">
    <template v-slot:top>
      <v-toolbar flat color="white">
        <v-toolbar-title>Lists</v-toolbar-title>
        <v-divider class="mx-4" inset vertical></v-divider>
        <v-spacer></v-spacer>
        <v-dialog v-model="dialog" max-width="500px">
          <template v-slot:activator="{ on }">
            <div v-if="isLoggedIn">
              <v-btn color="primary" dark class="mb-2" v-on="on">New List</v-btn>
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
                    <v-checkbox
                        v-model="editedItem.is_public"
                        label="Is public"
                    ></v-checkbox>
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
              <span class="headline">{{ "Show list" }}</span>
            </v-card-title>
            <v-card-text>
              <v-container>
                <v-row>
                  <v-col cols="12" sm="6" md="12">
                    <v-text-field readonly v-model="list.name" label="Name"></v-text-field>
                  </v-col>
                  <v-col cols="12" sm="12" md="12">
                    <v-checkbox readonly
                        v-model="list.is_public"
                        label="Is public"
                    ></v-checkbox>
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
      <div class="button-group">
        <button class="list-items-button" v-on:click="openLink(item)">
          <v-icon>list</v-icon>
          <div>Items</div>
        </button>
        <div v-if="isLoggedIn">
          <button class="list-items-button" v-on:click="getItem(item)">
            <v-icon>mdi-arrow-up-bold-box-outline</v-icon>
            <div>Show</div>
          </button>
          <button class="list-items-button" v-on:click="editItem(item)">
            <v-icon>edit</v-icon>
            <div>Edit</div>
          </button>
          <button class="list-items-button" v-on:click="deleteItem(item)">
            <v-icon>delete</v-icon>
            <div>Delete</div>
          </button>
        </div>
      </div>
    </template>
    <template v-slot:no-data>
      <v-btn color="primary" @click="initialize">Reset</v-btn>
    </template>
  </v-data-table>

</template>

<style scoped>

.button-group {
  display: flex;
  flex-direction: row;
}

.list-items-button {
  width: 60px;
  position: relative;
  display: block;
  padding: 0;
  overflow: hidden;
  border-width: 0;
  outline: none;
  border-radius: 2px;
  box-shadow: 0 1px 4px rgb(0 0 0 / 60%);
  background-color: #2f5cd6;
  color: #ffffff;
  transition: background-color .3s;
}

.list-items-button > .v-icon {
  color: white;
}
</style>



<script>
import axios from "axios";
import router from "@/router";
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
      { text: "Is public", value: "is_public" },
      { text: "User id", value: "user_id" },
      { text: "Actions", value: "action", sortable: false }
    ],
    lists: [],
    editedIndex: -1,
    editedItem: {
      name: "",
      is_public: false
    },
    defaultItem: {
      name: "",
      is_public: false
    },
    list: []
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
          .get("http://localhost:3000/lists", config)
          .then(response => {
            console.log(response.data);
            this.lists = response.data;
          })
          .catch(e => {
            console.log(e);
            router.push({ path: '/' })
          });
    },
    editItem(item) {
      this.editedIndex = item.id;
      this.editedItem = Object.assign({}, item);
      this.dialog = true;
    },
    deleteItem(item) {
      const index = this.lists.indexOf(item);
      confirm("Are you sure you want to delete this item?");
      const config = {
        headers: {
          authorization: localStorage.auth_token,
        },
      };
      axios
          .delete(`http://localhost:3000/lists/${item.id}`, config)
          .then(response => {
            console.log(response);
            alert("Record was successfully removed");
            this.initialize();
          })
          .catch(error => {
            console.log(error);
          });
      this.lists.splice(index, 1);
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
            .put(`http://localhost:3000/lists/${item.id}`, {
              name: this.editedItem.name,
              is_public: this.editedItem.is_public,
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
        axios
            .post(`http://localhost:3000/lists/`, {
              list: this.editedItem
            }, config)
            .then(response => {
              console.log(response);
              console.log("Created!");
              this.initialize();
            })
            .catch(error => {
              console.log(error);
            });
        this.lists.push(this.editedItem);
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
          .get(`http://localhost:3000/lists/${item.id}`, config)
          .then(response => {
            console.log(response.data);
            this.list = response.data;
          })
          .catch(error => {
            console.log(error);
          });
      this.showDialog = true;
    },
    openLink(item) {
      const listId = item.id
      let data = {
        listId: listId
      };
      router.push({ name: 'itemsList', params: data })
    }
  }
};
</script>