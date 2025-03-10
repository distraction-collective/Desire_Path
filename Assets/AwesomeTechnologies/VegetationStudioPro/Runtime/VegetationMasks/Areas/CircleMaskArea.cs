﻿using AwesomeTechnologies.Vegetation;
using AwesomeTechnologies.VegetationSystem;
using Unity.Burst;
using Unity.Collections;
using Unity.Jobs;
using Unity.Mathematics;
using UnityEngine;

namespace AwesomeTechnologies
{
//    [BurstCompile(CompileSynchronously = true)]
//         public struct SampleVegetatiomMaskCircleJob : IJob
//         {
//             public NativeList<VegetationInstance> VegetationInstanceList;
//             public float Radius;
//             public float3 MaskPosition;
//     
//             public void Execute()
//             {
//                 for (int i = VegetationInstanceList.Length - 1; i >= 0; i--)
//                 {
//                     VegetationInstance vegetationInstance = VegetationInstanceList[i];
//                     float2 position = new float2(vegetationInstance.Position.x, vegetationInstance.Position.z);
//     
//                     float distance = math.distance(position, new float2(MaskPosition.x, MaskPosition.z));
//                     if (distance < Radius)
//                     {
//                         VegetationInstanceList.RemoveAtSwapBack(i);
//                     }
//                 }
//             }
//         }


    [BurstCompile(CompileSynchronously = true)]
    public struct SampleVegetatiomMaskCircleJob : IJobParallelForDefer
    {
        [NativeDisableParallelForRestriction]
        public NativeList<float3> Position;
        [NativeDisableParallelForRestriction]
        public NativeList<byte> Excluded;
        public float Radius;
        public float3 MaskPosition;

        public void Execute(int index)
        {
            if (Excluded[index] == 1) return;
            
            float2 position = new float2(Position[index].x, Position[index].z);

            float distance = math.distance(position, new float2(MaskPosition.x, MaskPosition.z));
            if (distance < Radius)
            {
                Excluded[index] = 1;
            }
        }
    }

    public class CircleMaskArea : BaseMaskArea
    {
        public float Radius = 0.1f;
        public Vector3 Position;
        public VegetationType VegetationType;

        public void Init()
        {
            MaskBounds = GetMaskBounds();
        }

        public override JobHandle SampleMask(VegetationInstanceData instanceData, VegetationType vegetationType,
            JobHandle dependsOn)
        {
            if (VegetationType != vegetationType) return dependsOn;

            SampleVegetatiomMaskCircleJob sampleVegetatiomMaskCircleJob =
                new SampleVegetatiomMaskCircleJob
                {
                    MaskPosition = Position,
                    Radius = Radius,
                    Position = instanceData.Position,
                    Excluded = instanceData.Excluded

                };
            dependsOn = sampleVegetatiomMaskCircleJob.Schedule(instanceData.Excluded,32,dependsOn);

            return dependsOn;
        }

        private Bounds GetMaskBounds()
        {
            return new Bounds(Position, new Vector3(Radius * 2, Radius * 2, Radius * 2));
        }
    }
}