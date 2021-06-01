<template>
  <v-dialog v-model="dialog" persistent scrollable width="600">
    <template v-slot:activator="{ on }">
      <h3 class="title">
        Foto
        <v-btn color="indigo accent-2" ripple class="white--text font-weight-medium" icon v-on="on">
          <v-icon>refresh</v-icon>
        </v-btn>
      </h3>
      <img :src="current_user.profile_image_url" width="300px" height="300px">
    </template>

    <v-card>
      <v-toolbar flat dark color="primary">
        <v-toolbar-title>Atualizar foto</v-toolbar-title>
        <v-spacer />
        <v-btn :disabled="uploadInProgress" icon dark @click="dialog = false">
          <v-icon>close</v-icon>
        </v-btn>
      </v-toolbar>

      <v-card-text>
        <v-file-input
          :clearable="false"
          :disabled="uploadInProgress"
          class="mx-5"
          label="Enviar imagem"
          accept="image/*"
          @change="setImage"
        />
      </v-card-text>
      <v-card-text v-if="showCropper">
        <vue-croppie
          ref="croppieRef"
          :enable-orientation="true"
          :boundary="{ height: 400, width: 400 }"
          :viewport="{ height: 300, width: 300 }"
          :mouse-wheel-zoom="false"
          :enable-exif="true"
          :show-zoomer="true"
          :enable-resize="false"
        />
      </v-card-text>

      <v-card-actions v-if="uploadInProgress" class="mx-5">
        <v-progress-linear :value="uploadProgress" />
      </v-card-actions>
      <v-card-actions class="mx-5 py-5">
        <template v-if="showCropper">
          <v-btn :disabled="uploadInProgress" @click="rotate(-90)">
            <v-icon>rotate_left</v-icon>
          </v-btn>
          <v-btn :disabled="uploadInProgress" @click="rotate(90)">
            <v-icon>rotate_right</v-icon>
          </v-btn>
        </template>
        <v-spacer />
        <v-btn
          :disabled="uploadInProgress || !showCropper"
          color="pink accent-2"
          ripple
          class="white--text font-weight-medium"
          @click="cropImage"
        >
          Confirmar
        </v-btn>
      </v-card-actions>
    </v-card>
  </v-dialog>
</template>

<script>
import { VueCroppieComponent as VueCroppie } from "vue-croppie";
import "croppie/croppie.css";

export default {
  name: "ProfileUploadImage",
  components: {
    VueCroppie
  },
  props: {
    current_user: Object
  },
  data() {
    return {
      overlayProfileImage: false,
      dialog: false,
      showCropper: false,
      zoom: 100,
      uploadProgress: 0,
      uploadInProgress: false
    };
  },
  methods: {
    setImage(file) {
      if (!file.type.includes("image/")) {
        alert("Please select an image file");
        return;
      }
      if (typeof FileReader === "function") {
        this.showCropper = true;
        const reader = new FileReader();
        reader.onload = event => {
          this.$refs.croppieRef.bind({
            url: event.target.result
          });
        };
        reader.readAsDataURL(file);
      } else {
        alert("Sorry, FileReader API not supported");
      }
    },
    cropImage() {
      let options = {
        type: "blob",
        format: "jpeg",
        size: {
          width: 300,
          height: 300
        },
        quality: 0.85
      };
      this.$refs.croppieRef
        .result(options)
        .then(blob => this.uploadProfileImageData(blob));
    },

    uploadProfileImageData(file) {
      this.uploadInProgress = true;

      this.$http
        .get("/upload/presign", {
          params: {
            mimetype: file.type
          }
        })
        .then(({ data }) => {
          const { url, fields } = data;
          const formData = new FormData();

          Object.keys(fields).forEach(key => {
            formData.append(key, fields[key]);
          });

          formData.append("file", file);

          return this.$http
            .post(url, formData, {
              onUploadProgress: e => {
                this.$data.uploadProgress = Math.round(
                  (e.loaded * 100) / e.total
                );
              }
            })
            .then(() => {
              return { fields, file };
            });
        })
        .then(({ fields, file }) => {
          this.overlayProfileImage = true;
          let profile_image_data = {
            id: fields.key,
            storage: "store",
            metadata: {
              size: file.size,
              mime_type: file.type
            }
          };
          this.$apollo.mutate({
            mutation: require("@/graphql/UserUpdateProfileImage.gql"),
            variables: { profile_image_data }
          });
          this.dialog = false;
        })
        .catch(error => {
          console.log(error);
        })
        .finally(() => {
          this.uploadInProgress = false;
          this.overlayProfileImage = false;
        });
    },
    rotate(rotationAngle) {
      this.$refs.croppieRef.rotate(rotationAngle);
    }
  }
};
</script>
