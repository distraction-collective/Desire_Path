using UnityEngine;
using UnityEditor;
using UnityEditor.SceneManagement;

namespace VolumetricFogAndMist2 {

    public class VolumetricFog2EditorIntegration : MonoBehaviour {

        [MenuItem("GameObject/Effects/Volumetric Fog 2/Manager", false, 100)]
        public static void CreateManager(MenuCommand menuCommand) {
            VolumetricFogManager manager = Tools.CheckMainManager();
            if (StageUtility.GetCurrentStage() != StageUtility.GetMainStage()) {
                StageUtility.PlaceGameObjectInCurrentStage(manager.gameObject);
            }
            Selection.activeObject = manager.gameObject;
        }


        [MenuItem("GameObject/Effects/Volumetric Fog 2/Fog Volume", false, 120)]
        public static void CreateFogVolume(MenuCommand menuCommand) {
            GameObject go = VolumetricFogManager.CreateFogVolume("Volumetric Fog Volume");
            GameObjectUtility.SetParentAndAlign(go, menuCommand.context as GameObject);
            if (StageUtility.GetCurrentStage() != StageUtility.GetMainStage()) {
                StageUtility.PlaceGameObjectInCurrentStage(go);
            }
            Undo.RegisterCreatedObjectUndo(go, "Create Fog Volume");
            Selection.activeObject = go;
            PlaceGameObjectInFrontOfSceneView(go);
        }

        [MenuItem("GameObject/Effects/Volumetric Fog 2/Fog Void", false, 121)]
        public static void CreateFogVoid(MenuCommand menuCommand) {
            GameObject go = VolumetricFogManager.CreateFogVoid("Fog Void");
            GameObjectUtility.SetParentAndAlign(go, menuCommand.context as GameObject);
            if (StageUtility.GetCurrentStage() != StageUtility.GetMainStage()) {
                StageUtility.PlaceGameObjectInCurrentStage(go);
            }
            go.transform.localScale = new Vector3(30, 10, 30);
            Undo.RegisterCreatedObjectUndo(go, "Create Fog Void");
            Selection.activeObject = go;
            PlaceGameObjectInFrontOfSceneView(go);
        }

        [MenuItem("GameObject/Effects/Volumetric Fog 2/Fog Sub-Volume", false, 122)]
        public static void CreateFogSubVolume(MenuCommand menuCommand) {
            GameObject go = VolumetricFogManager.CreateFogSubVolume("Volumetric Fog Sub-Volume");
            GameObjectUtility.SetParentAndAlign(go, menuCommand.context as GameObject);
            if (StageUtility.GetCurrentStage() != StageUtility.GetMainStage()) {
                StageUtility.PlaceGameObjectInCurrentStage(go);
            }
            Undo.RegisterCreatedObjectUndo(go, "Create Volumetric Fog Sub-Volume");
            Selection.activeObject = go;
            PlaceGameObjectInFrontOfSceneView(go);
        }

        static void PlaceGameObjectInFrontOfSceneView(GameObject go) {
            var view = SceneView.lastActiveSceneView;
            if (view != null) {
                view.MoveToView(go.transform);
            }
        }

    }

}